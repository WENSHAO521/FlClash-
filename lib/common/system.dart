import 'dart:ffi';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ffi/ffi.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class System {
  static System? _instance;

  System._internal();

  factory System() {
    _instance ??= System._internal();
    return _instance!;
  }

  bool get isDesktop => isWindows || isMacOS || isLinux;

  bool get isWindows => Platform.isWindows;

  bool get isMacOS => Platform.isMacOS;

  bool get isAndroid => Platform.isAndroid;

  bool get isLinux => Platform.isLinux;

  Future<int> get version async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    return switch (Platform.operatingSystem) {
      'macos' => (deviceInfo as MacOsDeviceInfo).majorVersion,
      'android' => (deviceInfo as AndroidDeviceInfo).version.sdkInt,
      'windows' => (deviceInfo as WindowsDeviceInfo).majorVersion,
      String() => 0,
    };
  }

  Future<bool> checkIsAdmin() async {
    final corePath = appPath.corePath.replaceAll(' ', '\\\\ ');
    if (system.isWindows) {
      final result = await windows?.checkService();
      return result == WindowsHelperServiceStatus.running;
    } else if (system.isMacOS) {
      final result = await Process.run('stat', ['-f', '%Su:%Sg %Sp', corePath]);
      final output = result.stdout.trim();
      if (output.startsWith('root:admin') && output.contains('rws')) {
        return true;
      }
      return false;
    } else if (Platform.isLinux) {
      final result = await Process.run('stat', ['-c', '%U:%G %A', corePath]);
      final output = result.stdout.trim();
      if (output.startsWith('root:') && output.contains('rws')) {
        return true;
      }
      return false;
    }
    return true;
  }

  static String _shellEscape(String value) {
    return "'${value.replaceAll("'", "'\\''")}'";
  }

  Future<AuthorizeCode> authorizeCore() async {
    if (system.isAndroid) {
      return AuthorizeCode.error;
    }
    if (system.isWindows) {
      final result = await windows?.registerService();
      if (result == true) {
        return AuthorizeCode.success;
      }
      const message = 'Failed to register Windows helper service';
      commonPrint.log(message, logLevel: LogLevel.error);
      globalState.showNotifier(message);
      return AuthorizeCode.error;
    }

    final isAdmin = await checkIsAdmin();
    if (isAdmin) {
      return AuthorizeCode.none;
    }

    if (system.isMacOS) {
      final escapedPath = _shellEscape(appPath.corePath);
      final shell = 'chown root:admin $escapedPath && chmod +sx $escapedPath';
      final arguments = [
        '-e',
        'do shell script "$shell" with administrator privileges',
      ];
      final result = await Process.run('osascript', arguments);
      if (result.exitCode != 0) {
        return AuthorizeCode.error;
      }
      return AuthorizeCode.success;
    } else if (Platform.isLinux) {
      final shell = Platform.environment['SHELL'] ?? 'bash';
      final password = await globalState.showCommonDialog<String>(
        child: InputDialog(
          obscureText: true,
          title: currentAppLocalizations.pleaseInputAdminPassword,
          value: '',
        ),
      );
      if (password == null || password.isEmpty) {
        return AuthorizeCode.error;
      }
      final escapedPassword = _shellEscape(password);
      final escapedCorePath = _shellEscape(appPath.corePath);
      final arguments = [
        '-c',
        'echo $escapedPassword | sudo -S chown root:root $escapedCorePath && echo $escapedPassword | sudo -S chmod +sx $escapedCorePath',
      ];
      final result = await Process.run(shell, arguments);
      if (result.exitCode != 0) {
        return AuthorizeCode.error;
      }
      return AuthorizeCode.success;
    }
    return AuthorizeCode.error;
  }

  Future<void> back() async {
    await app?.moveTaskToBack();
    await window?.hide();
  }

  Future<void> exit() async {
    if (system.isAndroid) {
      await SystemNavigator.pop();
    }
    await window?.close();
    window?.forceExit();
  }
}

final system = System();

class Windows {
  static Windows? _instance;
  late DynamicLibrary _shell32;

  Windows._internal() {
    _shell32 = DynamicLibrary.open('shell32.dll');
  }

  factory Windows() {
    _instance ??= Windows._internal();
    return _instance!;
  }

  bool runas(String command, String arguments) {
    final commandPtr = command.toNativeUtf16();
    final argumentsPtr = arguments.toNativeUtf16();
    final operationPtr = 'runas'.toNativeUtf16();

    final shellExecute = _shell32
        .lookupFunction<
          Int32 Function(
            Pointer<Utf16> hwnd,
            Pointer<Utf16> lpOperation,
            Pointer<Utf16> lpFile,
            Pointer<Utf16> lpParameters,
            Pointer<Utf16> lpDirectory,
            Int32 nShowCmd,
          ),
          int Function(
            Pointer<Utf16> hwnd,
            Pointer<Utf16> lpOperation,
            Pointer<Utf16> lpFile,
            Pointer<Utf16> lpParameters,
            Pointer<Utf16> lpDirectory,
            int nShowCmd,
          )
        >('ShellExecuteW');

    final result = shellExecute(
      nullptr,
      operationPtr,
      commandPtr,
      argumentsPtr,
      nullptr,
      1,
    );

    calloc.free(commandPtr);
    calloc.free(argumentsPtr);
    calloc.free(operationPtr);

    commonPrint.log(
      'windows runas: $command $arguments resultCode:$result',
      logLevel: LogLevel.warning,
    );

    if (result <= 32) {
      return false;
    }
    return true;
  }

  @visibleForTesting
  String? parseServiceBinaryPath(String output) {
    for (final line in output.split(RegExp(r'\r?\n'))) {
      final parts = line.split(':');
      if (parts.length < 2) {
        continue;
      }
      if (parts.first.trim() != 'BINARY_PATH_NAME') {
        continue;
      }
      final value = parts.sublist(1).join(':').trim();
      if (value.isEmpty) {
        return null;
      }
      return value.replaceAll('"', '');
    }
    return null;
  }

  @visibleForTesting
  bool isSameWindowsPath(String a, String b) {
    return normalize(a).toLowerCase() == normalize(b).toLowerCase();
  }

  bool _isCurrentHelperPath(String? servicePath) {
    if (servicePath == null || servicePath.isEmpty) {
      return false;
    }
    return isSameWindowsPath(servicePath, appPath.helperPath);
  }

  // Future<void> _killProcess(int port) async {
  //   final result = await Process.run('netstat', ['-ano']);
  //   final lines = result.stdout.toString().trim().split('\n');
  //   for (final line in lines) {
  //     if (!line.contains(':$port') || !line.contains('LISTENING')) {
  //       continue;
  //     }
  //     final parts = line.trim().split(RegExp(r'\s+'));
  //     final pid = int.tryParse(parts.last);
  //     if (pid != null) {
  //      await Process.run('taskkill', ['/PID', pid.toString(), '/F']);
  //     }
  //   }
  // }

  // sc.exe can occasionally hang (e.g. SCM lock contention right after a
  // stop/delete/create/start cycle), and Process.run has no built-in
  // timeout, which would otherwise leave callers awaiting this forever
  // with no error and no way to fall back. Bound it so a stuck sc.exe
  // degrades to "unknown" instead of hanging core startup indefinitely.
  Future<ProcessResult?> _runScCommand(List<String> arguments) async {
    try {
      return await Process.run(
        'sc',
        arguments,
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      commonPrint.log(
        'sc.exe ${arguments.join(' ')} failed or timed out: $e',
        logLevel: LogLevel.warning,
      );
      return null;
    }
  }

  Future<WindowsHelperServiceStatus> checkService() async {
    final qcResult = await _runScCommand(['qc', appHelperService]);
    if (qcResult == null || qcResult.exitCode != 0) {
      return WindowsHelperServiceStatus.none;
    }
    final qcOutput = qcResult.stdout.toString();
    if (!_isCurrentHelperPath(parseServiceBinaryPath(qcOutput))) {
      commonPrint.log(
        'Windows helper service path mismatch: $qcOutput',
        logLevel: LogLevel.warning,
      );
      return WindowsHelperServiceStatus.presence;
    }

    final result = await _runScCommand(['query', appHelperService]);
    if (result == null || result.exitCode != 0) {
      return WindowsHelperServiceStatus.none;
    }
    final output = result.stdout.toString();
    if (output.contains('RUNNING') && await request.pingHelper()) {
      return WindowsHelperServiceStatus.running;
    }
    return WindowsHelperServiceStatus.presence;
  }

  Future<bool> registerService() async {
    final helperFile = File(appPath.helperPath);
    if (!await helperFile.exists()) {
      commonPrint.log(
        'Windows helper executable does not exist: ${appPath.helperPath}',
        logLevel: LogLevel.error,
      );
      return false;
    }

    if (await checkService() == WindowsHelperServiceStatus.running) {
      return true;
    }

    // A service stuck in "marked for deletion" (e.g. antivirus holding a
    // handle to the previous helper process, or a crashed instance) can make
    // a single stop/delete/create cycle fail even though it would succeed a
    // moment later. Give it one extra attempt before giving up.
    for (var attempt = 0; attempt < 2; attempt++) {
      final result = await _tryRegisterService();
      if (result.success) return true;
      if (result.status != WindowsHelperServiceStatus.presence) break;
      await Future.delayed(const Duration(seconds: 2));
    }
    return false;
  }

  Future<({bool success, WindowsHelperServiceStatus status})>
  _tryRegisterService() async {
    final status = await checkService();
    final logPath =
        '${Platform.environment['TEMP'] ?? Platform.environment['TMP'] ?? '.'}\\psg_helper_install.log';

    final commands = [
      if (status == WindowsHelperServiceStatus.presence) ...[
        'sc.exe stop $appHelperService',
        'taskkill /F /IM $appHelperService.exe',
        'sc.exe delete $appHelperService',
      ],
      'sc.exe stop $legacyAppHelperService',
      'taskkill /F /IM $legacyAppHelperService.exe',
      'sc.exe delete $legacyAppHelperService',
      'ping -n 3 127.0.0.1 >nul',
      'sc.exe create $appHelperService binPath= "${appPath.helperPath}" start= auto',
      'sc.exe start $appHelperService',
    ];
    final grouped = '(${commands.join(' & ')}) > "$logPath" 2>&1';
    final command = ['/d', '/s', '/c', grouped].join(' ');

    final res = runas('cmd.exe', command);

    await Future.delayed(const Duration(seconds: 1));
    final retryStatus = await retry(
      task: checkService,
      maxAttempts: 45,
      retryIf: (status) => status != WindowsHelperServiceStatus.running,
      delay: const Duration(seconds: 1),
    );
    final success = res && retryStatus == WindowsHelperServiceStatus.running;
    if (!success) {
      String installLog = '';
      try {
        installLog = await File(logPath).readAsString();
      } catch (_) {}
      final logs = await request.getHelperLogs();
      commonPrint.log(
        'Failed to register Windows helper service. status: $retryStatus '
        'installLog: $installLog logs: $logs',
        logLevel: LogLevel.error,
      );
    }
    return (success: success, status: retryStatus);
  }

  Future<bool> registerTask(String appName) async {
    final taskXml =
        '''
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <Principals>
    <Principal id="Author">
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Triggers>
    <LogonTrigger/>
  </Triggers>
  <Settings>
    <MultipleInstancesPolicy>Parallel</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>false</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>"${Platform.resolvedExecutable}"</Command>
    </Exec>
  </Actions>
</Task>''';
    final taskPath = join(await appPath.tempPath, 'task.xml');
    await File(taskPath).create(recursive: true);
    await File(
      taskPath,
    ).writeAsBytes(taskXml.encodeUtf16LeWithBom, flush: true);
    final commandLine = [
      '/Create',
      '/TN',
      appName,
      '/XML',
      '%s',
      '/F',
    ].join(' ');
    return runas('schtasks', commandLine.replaceFirst('%s', taskPath));
  }
}

final windows = system.isWindows ? Windows() : null;

class MacOS {
  static MacOS? _instance;

  List<String>? originDns;

  MacOS._internal();

  factory MacOS() {
    _instance ??= MacOS._internal();
    return _instance!;
  }

  Future<String?> get defaultServiceName async {
    final result = await Process.run('route', ['-n', 'get', 'default']);
    final output = result.stdout.toString();
    final deviceLine = output
        .split('\n')
        .firstWhere((s) => s.contains('interface:'), orElse: () => '');
    final lineSplits = deviceLine.trim().split(' ');
    if (lineSplits.length != 2) {
      return null;
    }
    final device = lineSplits[1];
    final serviceResult = await Process.run('networksetup', [
      '-listnetworkserviceorder',
    ]);
    final serviceResultOutput = serviceResult.stdout.toString();
    final currentService = serviceResultOutput
        .split('\n\n')
        .firstWhere((s) => s.contains('Device: $device'), orElse: () => '');
    if (currentService.isEmpty) {
      return null;
    }
    final currentServiceNameLine = currentService
        .split('\n')
        .firstWhere(
          (line) => RegExp(r'^\(\d+\).*').hasMatch(line),
          orElse: () => '',
        );
    final currentServiceNameLineSplits = currentServiceNameLine.trim().split(
      ' ',
    );
    if (currentServiceNameLineSplits.length < 2) {
      return null;
    }
    return currentServiceNameLineSplits[1];
  }

  Future<List<String>?> get systemDns async {
    final deviceServiceName = await defaultServiceName;
    if (deviceServiceName == null) {
      return null;
    }
    final result = await Process.run('networksetup', [
      '-getdnsservers',
      deviceServiceName,
    ]);
    final output = result.stdout.toString().trim();
    if (output.startsWith("There aren't any DNS Servers set on")) {
      originDns = [];
    } else {
      originDns = output.split('\n');
    }
    return originDns;
  }

  Future<void> updateDns(bool restore) async {
    final serviceName = await defaultServiceName;
    if (serviceName == null) {
      return;
    }
    List<String>? nextDns;
    if (restore) {
      nextDns = originDns;
    } else {
      final originDns = await systemDns;
      if (originDns == null) {
        return;
      }
      const needAddDns = '223.5.5.5';
      if (originDns.contains(needAddDns)) {
        return;
      }
      nextDns = List.from(originDns)..add(needAddDns);
    }
    if (nextDns == null) {
      return;
    }
    await Process.run('networksetup', [
      '-setdnsservers',
      serviceName,
      if (nextDns.isNotEmpty) ...nextDns,
      if (nextDns.isEmpty) 'Empty',
    ]);
  }
}

final macOS = system.isMacOS ? MacOS() : null;
