import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class AnimatedBackground extends StatelessWidget {
  final AnimationController controller;
  
  const AnimatedBackground({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(
            animation: controller,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  
  BackgroundPainter({required this.animation}) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Base background
    paint.color = AppColors.backgroundDark;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    
    // Animated gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.backgroundDark.withOpacity(0.8),
        AppColors.backgroundLight.withOpacity(0.5),
        AppColors.accentPrimary.withOpacity(0.3),
      ],
      stops: [
        0.1,
        0.5 + 0.2 * animation.value,
        0.9,
      ],
    );
    
    paint.shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
    
    // Draw animated circles
    _drawAnimatedCircles(canvas, size);
    
    // Draw grid lines
    _drawGridLines(canvas, size);
  }
  
  void _drawAnimatedCircles(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    // First circle
    final radius1 = 100 + 20 * animation.value;
    circlePaint.color = AppColors.accentPrimary.withOpacity(0.2);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      radius1,
      circlePaint,
    );
    
    // Second circle
    final radius2 = 150 - 30 * animation.value;
    circlePaint.color = AppColors.accentSecondary.withOpacity(0.15);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      radius2,
      circlePaint,
    );
    
    // Third circle
    final radius3 = 200 + 40 * animation.value;
    circlePaint.color = AppColors.primaryLight.withOpacity(0.1);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      radius3,
      circlePaint,
    );
  }
  
  void _drawGridLines(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.accentPrimary.withOpacity(0.1)
      ..strokeWidth = 0.5;
    
    // Horizontal lines
    final horizontalSpacing = size.height / 20;
    for (var i = 0; i < 20; i++) {
      final y = i * horizontalSpacing;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        linePaint,
      );
    }
    
    // Vertical lines
    final verticalSpacing = size.width / 20;
    for (var i = 0; i < 20; i++) {
      final x = i * verticalSpacing;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        linePaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
