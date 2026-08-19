import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';

class FloatLayout extends StatelessWidget {
  final Widget floatingWidget;

  final Widget child;

  const FloatLayout({
    super.key,
    required this.floatingWidget,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Pages using FloatLayout are pushed as non-opaque routes directly on
    // the root Navigator (see CommonRoute/CommonDesktopRoute), so on mobile
    // HomePage — including its own bottom NavigationBar — stays mounted and
    // visible behind them. A raw `bottom: 0` here would sit right on top of
    // that still-visible nav bar; add its height so the floating action
    // clears it instead of overlapping it.
    final isMobile = globalState.container.read(isMobileViewProvider);
    return Stack(
      fit: StackFit.loose,
      children: [
        Center(child: child),
        Positioned(
          bottom: isMobile ? kHomeNavigationBarHeight : 0,
          right: 0,
          child: SafeArea(top: false, child: floatingWidget),
        ),
      ],
    );
  }
}

class FloatWrapper extends StatelessWidget {
  final Widget child;

  const FloatWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(kFloatingActionButtonMargin),
      child: child,
    );
  }
}
