import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _matrixController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  
  final List<String> _codeSnippets = [
    'class Developer { String name = "Swapnaneel"; }',
    'if (coffee.isEmpty()) { productivity = 0; }',
    'while(learning) { skills++; }',
    'git commit -m "Another awesome feature"',
    'flutter build web --release',
    'const passion = "Flutter Development";',
    'function createMagic() { return code + creativity; }',
    'SELECT * FROM opportunities WHERE challenge = "accepted";',
    'import "dart:developer" as me;',
    'void main() => runApp(MyPortfolio());',
  ];
  
  final List<String> _matrixChars = [
    '0', '1', 'ア', 'イ', 'ウ', 'エ', 'オ', 'カ', 'キ', 'ク', 'ケ', 'コ',
    'サ', 'シ', 'ス', 'セ', 'ソ', 'タ', 'チ', 'ツ', 'テ', 'ト', 'ナ', 'ニ',
    'ヌ', 'ネ', 'ノ', 'ハ', 'ヒ', 'フ', 'ヘ', 'ホ', 'マ', 'ミ', 'ム', 'メ',
    'モ', 'ヤ', 'ユ', 'ヨ', 'ラ', 'リ', 'ル', 'レ', 'ロ', 'ワ', 'ヲ', 'ン',
  ];
  
  int _currentCodeIndex = 0;
  String _currentCode = '';
  Timer? _codeTimer;
  Timer? _typeTimer;
  int _typeIndex = 0;
  
  @override
  void initState() {
    super.initState();
    
    _matrixController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _startAnimations();
    _startCodeAnimation();
  }
  
  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 1000));
    _textController.forward();
    
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      context.go('/');
    }
  }
  
  void _startCodeAnimation() {
    _codeTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentCodeIndex = (_currentCodeIndex + 1) % _codeSnippets.length;
          _currentCode = '';
          _typeIndex = 0;
        });
        _startTyping();
      }
    });
    _startTyping();
  }
  
  void _startTyping() {
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_typeIndex < _codeSnippets[_currentCodeIndex].length) {
        setState(() {
          _currentCode = _codeSnippets[_currentCodeIndex].substring(0, _typeIndex + 1);
          _typeIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }
  
  @override
  void dispose() {
    _matrixController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _codeTimer?.cancel();
    _typeTimer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Matrix rain background
          CustomPaint(
            painter: MatrixRainPainter(_matrixController, _matrixChars),
            size: size,
          ),
          
          // Floating particles
          CustomPaint(
            painter: ParticlesPainter(_particleController),
            size: size,
          ),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoController.value,
                      child: Transform.rotate(
                        angle: _logoController.value * 2 * math.pi,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.accentPrimary,
                                AppColors.accentSecondary,
                                AppColors.accentTertiary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentPrimary.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'SS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Animated text
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textController.value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - _textController.value)),
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  AppColors.accentPrimary,
                                  AppColors.accentSecondary,
                                  AppColors.accentTertiary,
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'SWAPNANEEL SARKAR',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Flutter Developer • Problem Solver • Code Enthusiast',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.accentSecondary,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 60),
                
                // Code animation
                Container(
                  width: math.min(size.width * 0.8, 600),
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.accentPrimary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'terminal.dart',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '> $_currentCode${_typeIndex % 2 == 0 ? '|' : ''}',
                        style: const TextStyle(
                          color: AppColors.accentSecondary,
                          fontSize: 14,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Loading indicator
                AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final delay = index * 0.3;
                        final value = (_particleController.value + delay) % 1.0;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.accentPrimary.withOpacity(value),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MatrixRainPainter extends CustomPainter {
  final Animation<double> animation;
  final List<String> chars;
  final math.Random random = math.Random();
  
  MatrixRainPainter(this.animation, this.chars) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (int i = 0; i < 50; i++) {
      final x = (i * 20.0) % size.width;
      final y = (animation.value * size.height * 2 + i * 50) % (size.height + 100);
      
      for (int j = 0; j < 10; j++) {
        final charY = y - j * 20;
        if (charY > -20 && charY < size.height + 20) {
          final opacity = (1.0 - j * 0.1).clamp(0.0, 1.0);
          paint.color = AppColors.accentSecondary.withOpacity(opacity * 0.7);
          
          final textPainter = TextPainter(
            text: TextSpan(
              text: chars[random.nextInt(chars.length)],
              style: TextStyle(
                color: paint.color,
                fontSize: 16,
                fontFamily: 'monospace',
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          
          textPainter.layout();
          textPainter.paint(canvas, Offset(x, charY));
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  final math.Random random = math.Random();
  
  ParticlesPainter(this.animation) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (int i = 0; i < 30; i++) {
      final x = (random.nextDouble() * size.width + animation.value * 100) % size.width;
      final y = (random.nextDouble() * size.height + animation.value * 50) % size.height;
      
      paint.color = [
        AppColors.accentPrimary,
        AppColors.accentSecondary,
        AppColors.accentTertiary,
      ][i % 3].withOpacity(0.3);
      
      canvas.drawCircle(
        Offset(x, y),
        2 + math.sin(animation.value * 2 * math.pi + i) * 2,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
