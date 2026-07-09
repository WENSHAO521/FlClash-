import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/widgets/dialog.dart';
import 'package:flutter/material.dart';

class DownloadProgressDialog extends StatefulWidget {
  final UpdateAsset asset;

  const DownloadProgressDialog({super.key, required this.asset});

  @override
  State<DownloadProgressDialog> createState() =>
      _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  double? _progress;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final file = await Updater.download(
        widget.asset,
        onProgress: (count, total) {
          if (!mounted) return;
          setState(() {
            _progress = total > 0 ? count / total : null;
          });
        },
      );
      if (!mounted) return;
      Navigator.of(context).pop<File>(file);
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop<File>(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final progress = _progress;
    return CommonDialog(
      title: appLocalizations.downloadingUpdate,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Text(
              progress != null
                  ? '${(progress * 100).toStringAsFixed(0)}%'
                  : widget.asset.name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
