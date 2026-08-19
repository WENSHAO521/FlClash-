import 'dart:math';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'glass.dart';

class CommonDialog extends ConsumerWidget {
  final String title;
  final Widget? child;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final bool overrideScroll;
  final Color? backgroundColor;

  const CommonDialog({
    super.key,
    required this.title,
    this.actions,
    this.child,
    this.padding,
    this.overrideScroll = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, ref) {
    final size = ref.watch(viewSizeProvider);
    final content = Container(
      constraints: BoxConstraints(
        maxHeight: min(size.height - 40, 500),
        maxWidth: 300,
      ),
      width: size.width - 40,
      padding: padding ?? const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: !overrideScroll ? SingleChildScrollView(child: child) : child,
    );
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      // Real BackdropFilter blur here (via GlassSurface), unlike the old
      // AlertDialog which only tinted a flat color — matches the AppBar,
      // NavigationBar, and CommonPopupMenu, which all blur for real.
      child: GlassSurface(
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: backgroundColor ?? context.colorScheme.surfaceContainerHigh,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text(title, style: context.textTheme.headlineSmall),
            ),
            Flexible(child: content),
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!.separated(const SizedBox(width: 8)).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CommonModal extends ConsumerWidget {
  final Widget? child;

  const CommonModal({super.key, this.child});

  @override
  Widget build(BuildContext context, ref) {
    final size = ref.watch(viewSizeProvider);
    return Center(
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.85,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
