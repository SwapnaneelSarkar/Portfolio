import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' show PointMode;
import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Fixed "whiteboard after hours" canvas: a faint dot grid with a few slow,
/// soft glows drifting behind it. Sits behind the scroll view, so it never
/// moves with content.
class AnimatedBackground extends StatelessWidget {
  final AnimationController controller;

  const AnimatedBackground({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: CustomPaint(
              painter: BackgroundPainter(
                animation: reduceMotion ? null : controller,
              ),
            ),
          ),
          const RepaintBoundary(
            child: CustomPaint(painter: _DotGridPainter()),
          ),
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Animation<double>? animation;

  BackgroundPainter({this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = AppColors.backgroundDark);

    final t = (animation?.value ?? 0.15) * 2 * pi;

    _glow(
      canvas,
      Offset(
        size.width * (0.82 + 0.05 * sin(t)),
        size.height * (0.12 + 0.05 * cos(t)),
      ),
      size.shortestSide * 0.75,
      const Color(0xFF5B3FD9),
      0.32,
    );
    _glow(
      canvas,
      Offset(
        size.width * (0.08 + 0.06 * cos(t)),
        size.height * (0.78 + 0.04 * sin(t)),
      ),
      size.shortestSide * 0.7,
      const Color(0xFF3A2A9E),
      0.28,
    );
    _glow(
      canvas,
      Offset(
        size.width * (0.55 + 0.08 * sin(t + 1.4)),
        size.height * (0.5 + 0.06 * cos(t + 0.7)),
      ),
      size.shortestSide * 0.5,
      AppColors.marigold,
      0.05,
    );

    // Darken the edges so content in the middle reads first.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 1.1,
          colors: [
            Colors.transparent,
            AppColors.backgroundDark.withValues(alpha: 0.55),
          ],
          stops: const [0.55, 1],
        ).createShader(rect),
    );
  }

  void _glow(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double alpha,
  ) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 28.0;
    final coords = <double>[];
    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        coords..add(x)..add(y);
      }
    }
    canvas.drawRawPoints(
      PointMode.points,
      Float32List.fromList(coords),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.055)
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) => false;
}
