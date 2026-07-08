//go:build !cgo

package main

import (
	"encoding/binary"
	"encoding/json"
	"io"
	"sync"
	"time"
)

var (
	conn   io.ReadWriteCloser
	connMu sync.Mutex
)

func (result ActionResult) send() {
	data, err := result.Json()
	if err != nil {
		logError("ActionResult marshal error: method=%s id=%s err=%v", result.Method, result.Id, err)
		return
	}
	send(data)
}

func sendMessage(message Message) {
	result := ActionResult{
		Method: messageMethod,
		Data:   message,
	}
	result.send()
}

func writeFrame(w io.Writer, data []byte) error {
	frame := make([]byte, 4+len(data))
	binary.LittleEndian.PutUint32(frame, uint32(len(data)))
	copy(frame[4:], data)
	_, err := w.Write(frame)
	return err
}

func readFrame(r io.Reader) ([]byte, error) {
	lenBuf := make([]byte, 4)
	if _, err := io.ReadFull(r, lenBuf); err != nil {
		return nil, err
	}
	length := binary.LittleEndian.Uint32(lenBuf)
	data := make([]byte, length)
	if _, err := io.ReadFull(r, data); err != nil {
		return nil, err
	}
	return data, nil
}

func send(data []byte) {
	if conn == nil {
		logError("send conn nil")
		return
	}
	connMu.Lock()
	defer connMu.Unlock()
	if err := writeFrame(conn, data); err != nil {
		logError("server write error: %v", err)
	}
}

func startServer(arg string) {
	var err error
	// A client that connects to a named pipe and disconnects again without
	// the server calling accept() in between leaves that pipe instance
	// dead-on-arrival until the next accept() cleans it up. Right after a
	// restart (e.g. toggling TUN, which tears down and relaunches this
	// process against the same pipe) this process can start dialing before
	// the server side has looped back around to accept() again, which
	// surfaces here as an immediate i/o timeout. Retry for a few seconds
	// instead of panicking on the first attempt.
	for attempt := 0; ; attempt++ {
		conn, err = dial(arg)
		if err == nil {
			break
		}
		if attempt >= 19 {
			panic(err.Error())
		}
		time.Sleep(250 * time.Millisecond)
	}

	defer func(conn io.Closer) {
		_ = conn.Close()
	}(conn)

	for {
		data, err := readFrame(conn)
		if err != nil {
			if err != io.EOF {
				logError("server read error: %v", err)
			}
			return
		}
		var action = &Action{}

		err = json.Unmarshal(data, action)

		if err != nil {
			logError("server unmarshal error: %v (data: %q)", err, data)
			continue
		}

		result := ActionResult{
			Id:     action.Id,
			Method: action.Method,
		}

		go handleAction(action, result)
	}
}

func nextHandle(action *Action, result ActionResult) bool {
	return false
}
