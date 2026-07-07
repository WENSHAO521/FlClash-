use once_cell::sync::Lazy;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::VecDeque;
use std::fs::File;
use std::io::{BufRead, Error, Read};
use std::process::{Command, Stdio};
use std::sync::{Arc, Mutex};
use std::time::SystemTime;
use std::{io, thread};
use warp::{Filter, Reply};

#[cfg(windows)]
use std::os::windows::process::CommandExt;
#[cfg(windows)]
use std::time::{Duration, Instant};

const LISTEN_PORT: u16 = 47890;

#[cfg(windows)]
const CREATE_NEW_PROCESS_GROUP: u32 = 0x0000_0200;
#[cfg(windows)]
const CTRL_BREAK_EVENT: u32 = 1;

#[cfg(windows)]
extern "system" {
    fn GenerateConsoleCtrlEvent(dw_ctrl_event: u32, dw_process_group_id: u32) -> i32;
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct StartParams {
    pub path: String,
    pub arg: String,
}

fn sha256_file(path: &str) -> Result<String, Error> {
    let mut file = File::open(path)?;
    let mut hasher = Sha256::new();
    let mut buffer = [0; 4096];

    loop {
        let bytes_read = file.read(&mut buffer)?;
        if bytes_read == 0 {
            break;
        }
        hasher.update(&buffer[..bytes_read]);
    }

    Ok(format!("{:x}", hasher.finalize()))
}

static SHA256_CACHE: Lazy<Mutex<Option<(String, SystemTime, String)>>> =
    Lazy::new(|| Mutex::new(None));

// Hashing the whole core binary on every /start call can take several
// seconds (slow disk, antivirus scanning), which easily blows past the
// caller's timeout even though the eventual result never changes for an
// unmodified file. Cache it keyed by the file's mtime so only the first
// call (or a call after the binary is replaced) pays that cost.
fn cached_sha256_file(path: &str) -> Result<String, Error> {
    let mtime = std::fs::metadata(path)?.modified()?;

    if let Ok(mut cache) = SHA256_CACHE.lock() {
        if let Some((cached_path, cached_mtime, cached_hash)) = cache.as_ref() {
            if cached_path == path && *cached_mtime == mtime {
                return Ok(cached_hash.clone());
            }
        }
        let hash = sha256_file(path)?;
        *cache = Some((path.to_string(), mtime, hash.clone()));
        return Ok(hash);
    }

    sha256_file(path)
}

static LOGS: Lazy<Arc<Mutex<VecDeque<String>>>> =
    Lazy::new(|| Arc::new(Mutex::new(VecDeque::with_capacity(100))));
static PROCESS: Lazy<Arc<Mutex<Option<std::process::Child>>>> =
    Lazy::new(|| Arc::new(Mutex::new(None)));

fn start(start_params: StartParams) -> impl Reply {
    if !cfg!(debug_assertions) {
        let sha256 = cached_sha256_file(start_params.path.as_str()).unwrap_or("".to_string());
        if sha256 != env!("TOKEN") {
            return format!("The SHA256 hash of the program requesting execution is: {}. The helper program only allows execution of applications with the SHA256 hash: {}.", sha256,  env!("TOKEN"),);
        }
    }
    stop();
    let mut process = PROCESS.lock().unwrap();
    let mut command = Command::new(&start_params.path);
    command.stderr(Stdio::piped()).arg(&start_params.arg);
    // Puts the child in its own process group so stop() can later target
    // just this process with a graceful console-control event instead of
    // only ever being able to force-kill it.
    #[cfg(windows)]
    command.creation_flags(CREATE_NEW_PROCESS_GROUP);
    match command.spawn() {
        Ok(child) => {
            *process = Some(child);
            if let Some(ref mut child) = *process {
                let stderr = child.stderr.take().unwrap();
                let reader = io::BufReader::new(stderr);
                thread::spawn(move || {
                    for line in reader.lines() {
                        match line {
                            Ok(output) => {
                                log_message(output);
                            }
                            Err(_) => {
                                break;
                            }
                        }
                    }
                });
            }
            "".to_string()
        }
        Err(e) => {
            log_message(e.to_string());
            e.to_string()
        }
    }
}

fn stop() -> impl Reply {
    let mut process = PROCESS.lock().unwrap();
    if let Some(mut child) = process.take() {
        let mut exited = false;

        // TerminateProcess (what child.kill() calls on Windows) gives the
        // core no chance to run its own shutdown/cleanup, which leaves the
        // wintun virtual network adapter it created behind in a broken,
        // orphaned state - observed accumulating across repeated
        // start/stop cycles. Ask it to exit gracefully first via a console
        // control event and only fall back to a hard kill if it doesn't
        // respond in time.
        #[cfg(windows)]
        {
            let pid = child.id();
            unsafe {
                GenerateConsoleCtrlEvent(CTRL_BREAK_EVENT, pid);
            }
            let deadline = Instant::now() + Duration::from_secs(3);
            while Instant::now() < deadline {
                match child.try_wait() {
                    Ok(Some(_)) => {
                        exited = true;
                        break;
                    }
                    Ok(None) => thread::sleep(Duration::from_millis(100)),
                    Err(_) => break,
                }
            }
        }

        if !exited {
            let _ = child.kill();
            let _ = child.wait();
        }
    }
    *process = None;
    "".to_string()
}

fn log_message(message: String) {
    let mut log_buffer = LOGS.lock().unwrap();
    if log_buffer.len() == 100 {
        log_buffer.pop_front();
    }
    log_buffer.push_back(format!("{}\n", message));
}

fn get_logs() -> impl Reply {
    let log_buffer = LOGS.lock().unwrap();
    let value = log_buffer
        .iter()
        .cloned()
        .collect::<Vec<String>>()
        .join("\n");
    warp::reply::with_header(value, "Content-Type", "text/plain")
}

pub async fn run_service() -> anyhow::Result<()> {
    let api_ping = warp::get().and(warp::path("ping")).map(|| env!("TOKEN"));

    let api_start = warp::post()
        .and(warp::path("start"))
        .and(warp::body::json())
        .map(|start_params: StartParams| start(start_params));

    let api_stop = warp::post().and(warp::path("stop")).map(|| stop());

    let api_logs = warp::get().and(warp::path("logs")).map(|| get_logs());

    warp::serve(api_ping.or(api_start).or(api_stop).or(api_logs))
        .run(([127, 0, 0, 1], LISTEN_PORT))
        .await;

    Ok(())
}
