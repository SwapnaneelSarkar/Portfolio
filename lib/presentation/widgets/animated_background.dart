import 'dart:math';
import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  final AnimationController controller;
  
  const AnimatedBackground({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _particleController;
  final List<Particle> _particles = [];
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    
    // Initialize particles
    _initParticles();
  }
  
  void _initParticles() {
    // Create 30 particles with random properties
    for (int i = 0; i < 30; i++) {
      _particles.add(
        Particle(
          position: Offset(
            _random.nextDouble() * 1000,
            _random.nextDouble() * 1000,
          ),
          size: 2 + _random.nextDouble() * 5,
          color: _getRandomColor(),
          speed: 10 + _random.nextDouble() * 30,
          direction: _random.nextDouble() * 2 * pi,
          opacity: 0.3 + _random.nextDouble() * 0.4,
        ),
      );
    }
  }
  
  Color _getRandomColor() {
    final colors = [
      AppColors.accentPrimary,
      AppColors.primaryGreenLight,
      AppColors.accentTertiary,
      AppColors.accentTertiary,
      AppColors.primaryAccentLight,
      AppColors.primaryGreenLight,
    ];
    return colors[_random.nextInt(colors.length)];
  }
  
  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            return CustomPaint(
              painter: BackgroundPainter(
                animation: widget.controller,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
              ),
            );
          },
        ),
        
        // Floating elements
        Positioned(
          top: 100,
          right: 100,
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  sin(widget.controller.value * 2 * pi) * 20,
                ),
                child: Transform.rotate(
                  angle: widget.controller.value * 0.2,
                  child: child,
                ),
              );
            },
            child: _buildLaptop(),
          ),
        ),
        
        Positioned(
          top: 300,
          left: 100,
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  sin(widget.controller.value * 2 * pi) * 15,
                  cos(widget.controller.value * 2 * pi) * 15,
                ),
                child: Transform.rotate(
                  angle: -widget.controller.value * 0.1,
                  child: child,
                ),
              );
            },
            child: _buildMobilePhone(),
          ),
        ),
        
        Positioned(
          bottom: 200,
          left: 150,
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  cos(widget.controller.value * 2 * pi) * 25,
                  sin(widget.controller.value * 2 * pi) * 10,
                ),
                child: Transform.rotate(
                  angle: widget.controller.value * 0.3,
                  child: child,
                ),
              );
            },
            child: _buildCodeBlock(),
          ),
        ),
        
        // Animated particles
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlesPainter(
                particles: _particles,
                animation: _particleController,
              ),
              size: Size.infinite,
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildLaptop() {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.accentPrimary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPrimary.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Laptop screen
          Positioned(
            top: 5,
            left: 5,
            right: 5,
            bottom: 15,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Icon(
                  Icons.code,
                  color: AppColors.accentPrimary.withOpacity(0.7),
                  size: 20,
                ),
              ),
            ),
          ),
          // Laptop base
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryAccentLight.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMobilePhone() {
    return Container(
      width: 40,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.accentTertiary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentTertiary.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Phone screen
          Positioned(
            top: 5,
            left: 5,
            right: 5,
            bottom: 15,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Icon(
                  Icons.flutter_dash,
                  color: AppColors.primaryGreenLight.withOpacity(0.7),
                  size: 15,
                ),
              ),
            ),
          ),
          // Home button
          Positioned(
            bottom: 5,
            left: 15,
            right: 15,
            height: 5,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryYellowLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCodeBlock() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.accentSecondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentSecondary.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '</>\ncode',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.accentSecondary.withOpacity(0.7),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
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
    circlePaint.color = AppColors.primaryAccentLight.withOpacity(0.1);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      radius3,
      circlePaint,
    );
    
    // Fourth circle - new
    final radius4 = 120 - 20 * animation.value;
    circlePaint.color = AppColors.accentTertiary.withOpacity(0.12);
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.8),
      radius4,
      circlePaint,
    );
    
    // Fifth circle - new
    final radius5 = 180 + 30 * animation.value;
    circlePaint.color = AppColors.primaryAccentLight.withOpacity(0.08);
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.2),
      radius5,
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

class Particle {
  Offset position;
  double size;
  Color color;
  double speed;
  double direction;
  double opacity;
  
  Particle({
    required this.position,
    required this.size,
    required this.color,
    required this.speed,
    required this.direction,
    required this.opacity,
  });
  
  void update(double delta, Size size) {
    final dx = cos(direction) * speed * delta;
    final dy = sin(direction) * speed * delta;
    
    position = Offset(
      (position.dx + dx).clamp(0, size.width),
      (position.dy + dy).clamp(0, size.height),
    );
    
    // Change direction if hitting the edge
    if (position.dx <= 0 || position.dx >= size.width) {
      direction = pi - direction;
    }
    
    if (position.dy <= 0 || position.dy >= size.height) {
      direction = -direction;
    }
  }
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final Animation<double> animation;
  
  ParticlesPainter({
    required this.particles,
    required this.animation,
  }) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    // Update and draw particles
    for (final particle in particles) {
      particle.update(0.016, size); // Assuming 60fps
      
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        particle.position,
        particle.size,
        paint,
      );
      
      // Draw connecting lines between nearby particles
      for (final otherParticle in particles) {
        if (particle == otherParticle) continue;
        
        final distance = (particle.position - otherParticle.position).distance;
        if (distance < 100) {
          final linePaint = Paint()
            ..color = particle.color.withOpacity(0.1 * (1 - distance / 100))
            ..strokeWidth = 0.5;
          
          canvas.drawLine(
            particle.position,
            otherParticle.position,
            linePaint,
          );
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
