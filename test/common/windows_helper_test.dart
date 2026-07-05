import 'dart:io';

import 'package:fl_clash/common/system.dart';
import 'package:test/test.dart';

void main() {
  group('Windows helper service parsing', () {
    test('extracts binary path from sc qc output with drive colon', () {
      final windows = Windows();
      const output = '''
[SC] QueryServiceConfig SUCCESS

SERVICE_NAME: PSGHelperService
        TYPE               : 10  WIN32_OWN_PROCESS
        BINARY_PATH_NAME   : "D:\\PSA\\PSGHelperService.exe"
        START_TYPE         : 2   AUTO_START
''';

      expect(
        windows.parseServiceBinaryPath(output),
        r'D:\PSA\PSGHelperService.exe',
      );
    });

    test('compares Windows paths case-insensitively', () {
      final windows = Windows();
      expect(
        windows.isSameWindowsPath(
          r'D:\PSA\PSGHelperService.exe',
          r'd:\psa\PSGHelperService.exe',
        ),
        true,
      );
    });
  }, skip: !Platform.isWindows);
}
