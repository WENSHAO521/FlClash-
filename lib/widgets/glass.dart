import 'dart:ui';

import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';

/// Shared frosted-glass tokens.
///
/// The app shell paints one [AmbientBackground] behind everything; chrome
/// surfaces (top bar, nav rail/bar, dialogs, settings groups) then sit on
/// top of it as translucent, blurred [GlassSurface]s instead of opaque
/// Material colors, so the gradient reads through the whole app.
const glassBlurSigma = 24.0;
const glassPanelOpacityLight = 0.36;
const glassPanelOpacityDark = 0.50;
const glassBorderOpacity = 0.10;
const glassDividerOpacity = 0.24;

/// Light mode reads muddier at high opacity (the tint dominates a bright
/// background), so it sits lower than dark mode to keep the same "frosted"
/// feel in both themes.
double glassPanelOpacityFor(Brightness brightness) =>
    brightness == Brightness.dark ? glassPanelOpacityDark : glassPanelOpacityLight;

/// A translucent surface that optionally blurs whatever sits behind it.
///
/// Blur is real (a [BackdropFilter]) for surfaces that only ever appear once
/// on screen at a time — the top bar, the nav rail/bar, dialogs, settings
/// groups. It's deliberately skipped (translucency only, `blurSigma: 0`) for
/// anything that can appear dozens of times at once, like proxy cards in a
/// list — stacking that many backdrop filters is a real scroll-jank risk,
/// and a flat tint over the ambient gradient still reads as "glass" there.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final OutlinedBorder shape;
  final Color? color;
  final double? opacity;
  final double blurSigma;
  final BorderSide? borderSide;
  final List<BoxShadow>? boxShadow;

  const GlassSurface({
    super.key,
    required this.child,
    this.shape = const RoundedRectangleBorder(),
    this.color,
    this.opacity,
    this.blurSigma = glassBlurSigma,
    this.borderSide,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final baseColor = color ?? colorScheme.surfaceContainer;
    final resolvedOpacity = opacity ?? glassPanelOpacityFor(colorScheme.brightness);
    final tintedShape = borderSide != null
        ? shape.copyWith(side: borderSide)
        : shape;
    final surface = DecoratedBox(
      decoration: ShapeDecoration(
        shape: tintedShape,
        color: baseColor.withValues(alpha: resolvedOpacity),
        shadows: boxShadow,
      ),
      child: child,
    );
    if (blurSigma <= 0) {
      return ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: surface,
      );
    }
    return ClipPath(
      clipper: ShapeBorderClipper(shape: shape),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: surface,
      ),
    );
  }
}

/// The ambient gradient + soft color blobs painted once behind the whole app
/// shell (top bar, sidebar, page content all sit above it, translucent).
/// Derives from the active [ColorScheme] so it follows both dynamic color
/// and the user's chosen primary color automatically.
class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final tintStrength = isDark ? 0.30 : 0.12;
    final blobStrength = isDark ? 0.26 : 0.16;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface,
            Color.lerp(colorScheme.surface, colorScheme.primary, tintStrength)!,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -140,
            right: -100,
            child: _GlassBlob(color: colorScheme.primary, opacity: blobStrength),
          ),
          Positioned(
            bottom: -180,
            left: -120,
            child: _GlassBlob(
              color: colorScheme.tertiary,
              opacity: blobStrength * 0.85,
              size: 460,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassBlob extends StatelessWidget {
  final Color color;
  final double opacity;
  final double size;

  const _GlassBlob({required this.color, required this.opacity, this.size = 380});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: opacity), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
