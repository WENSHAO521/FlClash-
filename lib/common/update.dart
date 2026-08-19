import 'dart:ffi';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:path/path.dart' as p;

class UpdateAsset {
  final String name;
  final String url;

  const UpdateAsset({required this.name, required this.url});
}

class Updater {
  static Future<String> get _desktopArch async {
    final abi = Abi.current();
    switch (abi) {
      case Abi.windowsArm64:
      case Abi.linuxArm64:
      case Abi.macosArm64:
        return 'arm64';
      default:
        return 'amd64';
    }
  }

  static Future<List<String>> _androidAbiPreference() async {
    try {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final abis = deviceInfo.supportedAbis;
      if (abis.isNotEmpty) return abis;
    } catch (_) {}
    return ['arm64-v8a', 'armeabi-v7a', 'x86_64'];
  }

  /// Picks the release asset matching the current platform/arch from a
  /// GitHub release API `assets` array.
  static Future<UpdateAsset?> pickAsset(List<dynamic> assets) async {
    final items = assets
        .whereType<Map>()
        .map(
          (e) => UpdateAsset(
            name: e['name'] as String? ?? '',
            url: e['browser_download_url'] as String? ?? '',
          ),
        )
        .where((asset) => asset.name.isNotEmpty && asset.url.isNotEmpty)
        .toList();
    if (items.isEmpty) return null;

    if (system.isAndroid) {
      for (final abi in await _androidAbiPreference()) {
        final match = items.where(
          (asset) => asset.name.contains('-android-$abi.apk'),
        );
        if (match.isNotEmpty) return match.first;
      }
      return null;
    }

    if (system.isWindows) {
      final arch = await _desktopArch;
      final match = items.where(
        (asset) => asset.name.contains('-windows-$arch-setup.exe'),
      );
      return match.isNotEmpty ? match.first : null;
    }

    if (system.isMacOS) {
      final arch = await _desktopArch;
      final match = items.where(
        (asset) => asset.name.contains('-macos-$arch.dmg'),
      );
      return match.isNotEmpty ? match.first : null;
    }

    if (system.isLinux) {
      final arch = await _desktopArch;
      final preferredExts = ['.AppImage', '.deb', '.rpm'];
      for (final ext in preferredExts) {
        final match = items.where(
          (asset) =>
              asset.name.contains('-linux-$arch') && asset.name.endsWith(ext),
        );
        if (match.isNotEmpty) return match.first;
      }
      return null;
    }

    return null;
  }

  /// Downloads [asset] into the app's temp directory, reporting progress
  /// through [onProgress] (received bytes, total bytes).
  static Future<File> download(
    UpdateAsset asset, {
    void Function(int count, int total)? onProgress,
  }) async {
    final dir = await appPath.tempDir.future;
    final filePath = p.join(dir.path, asset.name);
    await request.dio.download(
      asset.url,
      filePath,
      onReceiveProgress: onProgress,
    );
    return File(filePath);
  }

  /// Hands the downloaded artifact off to the platform installer. On
  /// Windows/Linux/macOS this still surfaces a native install prompt (UAC,
  /// Finder, or the desktop's package handler) — a fully silent, no-prompt
  /// install isn't possible without code-signing (macOS Gatekeeper) or root
  /// (Android), see the disclaimer/README.
  static Future<void> install(File file) async {
    if (system.isWindows) {
      await Process.start(file.path, [], mode: ProcessStartMode.detached);
      return;
    }
    if (system.isMacOS) {
      await Process.run('open', [file.path]);
      return;
    }
    if (system.isLinux) {
      if (file.path.endsWith('.AppImage')) {
        await Process.run('chmod', ['+x', file.path]);
      }
      await Process.run('xdg-open', [file.path]);
      return;
    }
    if (system.isAndroid) {
      await app?.openFile(file.path);
      return;
    }
  }
}
