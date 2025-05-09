import 'dart:math';
import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class FloatingParticles extends StatelessWidget {
  final AnimationController controller;
  
  const FloatingParticles({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(
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

class Particle {
  Offset position;
  double radius;
  Color color;
  double speed;
  double direction;
  
  Particle({
    required this.position,
    required this.radius,
    required this.color,
    required this.speed,
    required this.direction,
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
  final Animation<double> animation;
  final List<Particle> particles = [];
  final Random random = Random();
  
  ParticlesPainter({required this.animation}) : super(repaint: animation) {
    _initParticles();
  }
  
  void _initParticles() {
    // Create 50 particles
    for (var i = 0; i < 50; i++) {
      final color = [
        AppColors.accentPrimary,
        AppColors.accentSecondary,
        AppColors.primaryLight,
      ][random.nextInt(3)];
      
      particles.add(
        Particle(
          position: Offset(
            random.nextDouble() * 1000,
            random.nextDouble() * 1000,
          ),
          radius: 1 + random.nextDouble() * 2,
          color: color.withOpacity(0.2 + random.nextDouble() * 0.3),
          speed: 5 + random.nextDouble() * 15,
          direction: random.nextDouble() * 2 * pi,
        ),
      );
    }
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    // Update particles
    for (final particle in particles) {
      particle.update(0.016, size); // Assuming 60fps
      
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        particle.position,
        particle.radius,
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
