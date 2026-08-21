import 'dart:math';
import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Deep-space backdrop: slow-drifting aurora glows over a fine dot grid.
class AnimatedBackground extends StatelessWidget {
  final AnimationController controller;

  /// Kept for call-site compatibility; the old particle network was removed.
  final bool showParticles;

  /// Kept for call-site compatibility; floating decorations were removed.
  final bool showFloatingDecorations;

  const AnimatedBackground({
    super.key,
    required this.controller,
    this.showParticles = false,
    this.showFloatingDecorations = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Static dot grid — rasterized once, never repainted with the aurora.
        const RepaintBoundary(
          child: CustomPaint(
            painter: _DotGridPainter(),
            child: SizedBox.expand(),
          ),
        ),
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              // Quantize to ~30 updates/sec: imperceptible on a 24s drift,
              // halves full-viewport raster work on CanvasKit.
              final t = (controller.value * 720).floorToDouble() / 720;
              return CustomPaint(
                painter: _AuroraPainter(t: t),
                child: const SizedBox.expand(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Static base — the animated layer above only paints translucent glows.
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundDark,
            Color(0xFF070B14),
            AppColors.backgroundDark,
          ],
        ).createShader(rect),
    );
    const spacing = 44.0;
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.035);
    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) => false;
}

class _AuroraPainter extends CustomPainter {
  final double t;

  _AuroraPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final phase = t * 2 * pi;
    final d = min(size.width, size.height);

    _glow(
      canvas,
      center: Offset(
        size.width * (0.82 + 0.05 * sin(phase)),
        size.height * (0.12 + 0.05 * cos(phase)),
      ),
      radius: d * 0.55,
      color: AppColors.accentPrimary.withValues(alpha: 0.07),
    );
    _glow(
      canvas,
      center: Offset(
        size.width * (0.08 + 0.05 * cos(phase + 1.3)),
        size.height * (0.55 + 0.06 * sin(phase + 1.3)),
      ),
      radius: d * 0.5,
      color: AppColors.accentSecondary.withValues(alpha: 0.065),
    );
    _glow(
      canvas,
      center: Offset(
        size.width * (0.55 + 0.06 * sin(phase + 2.6)),
        size.height * (0.95 + 0.04 * cos(phase + 2.6)),
      ),
      radius: d * 0.45,
      color: AppColors.accentTertiary.withValues(alpha: 0.045),
    );
  }

  void _glow(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
  }) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) =>
      oldDelegate.t != t;
}
