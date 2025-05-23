import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/assets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class ExperiencePreview extends StatefulWidget {
  const ExperiencePreview({Key? key}) : super(key: key);

  @override
  State<ExperiencePreview> createState() => _ExperiencePreviewState();
}

class _ExperiencePreviewState extends State<ExperiencePreview> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _matrixController;
  late final AnimationController _pulseController;
  bool _isVisible = false;
  int? _hoveredCardIndex;
  
  final List<Map<String, dynamic>> _experiences = [
    {
      'company': 'Laugh Buddha Technologies pvt. Ltd.',
      'position': 'Flutter Developer (Intern)',
      'period': 'April, 2025 - Present',
      'description': 'Sole Flutter developer responsible for end-to-end mobile app development using BLoC architecture and reusable component design.',
      'details': [
        'Developed and maintained mobile applications using Flutter and Dart',
        'Implemented BLoC architecture for state management',
        'Created reusable UI components for consistent design',
      ],
      'color': AppColors.accentPrimary,
      'icon': FontAwesomeIcons.mobileScreen,
      'techStack': ['Flutter', 'Dart', 'BLoC', 'Firebase'],
      'achievements': ['100% code coverage', 'Zero crashes in production'],
    },
    {
      'company': 'Taxian',
      'position': 'Software Developer (Intern)',
      'period': 'March, 2025 - April, 2025',
      'description': 'Developed UI for web applications using Flutter, ensuring seamless user experiences.',
      'details': [
        'Developed web UI using Flutter for cross-platform compatibility',
        'Integrated RESTful APIs for data fetching and manipulation',
        'Implemented Firebase Cloud Messaging for notifications',
      ],
      'color': AppColors.accentSecondary,
      'icon': FontAwesomeIcons.globe,
      'techStack': ['Flutter Web', 'REST APIs', 'FCM', 'JavaScript'],
      'achievements': ['50% improvement in load time', 'Mobile-first design'],
    },
    {
      'company': 'Freelance',
      'position': 'Flutter Developer',
      'period': 'January, 2024 - Present',
      'description': 'Working on various client projects, delivering custom Flutter applications with focus on Google-oriented technologies.',
      'details': [
        'Designed and developed custom Flutter applications for clients',
        'Implemented complex UI designs and animations',
        'Integrated third-party services and APIs',
      ],
      'color': AppColors.primaryLight,
      'icon': FontAwesomeIcons.code,
      'techStack': ['Flutter', 'Firebase', 'Google APIs', 'Third-party SDKs'],
      'achievements': ['15+ successful projects', '5-star client ratings'],
    },
  ];

  final List<String> _matrixChars = [
    '0', '1', '{', '}', '[', ']', '(', ')', '<', '>', 
    'class', 'void', 'int', 'String', 'bool', 'List',
    'if', 'else', 'for', 'while', 'return', 'await',
  ];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _matrixController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    // Add post-frame callback to start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isVisible = true;
      });
      _controller.forward();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _matrixController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final isMobile = size.width < 768;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Stack(
        children: [
          // Animated matrix background
          CustomPaint(
            painter: CodeMatrixPainter(_matrixController, _matrixChars),
            size: size,
          ),
          
          Column(
            children: [
              // Enhanced Section Header
              _buildEnhancedHeader(textTheme),
              const SizedBox(height: 60),
              
              // Content
              isMobile
                  ? Column(
                      children: [
                        _buildExperienceCards(textTheme),
                        const SizedBox(height: 40),
                        _buildExperienceAnimation(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildExperienceCards(textTheme),
                        ),
                        Expanded(
                          flex: 2,
                          child: _buildExperienceAnimation(),
                        ),
                      ],
                    ),
              
              // Enhanced View more button
              const SizedBox(height: 40),
              _buildEnhancedButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Column(
          children: [
            // Binary decoration
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                '01000101 01111000 01110000 01100101 01110010 01101001 01100101 01101110 01100011 01100101',
                style: TextStyle(
                  color: AppColors.accentSecondary.withOpacity(0.3 + 0.2 * _pulseController.value),
                  fontSize: 12,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Main title with enhanced styling
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.terminal,
                    color: AppColors.accentPrimary,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Experience',
                    style: textTheme.displaySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentPrimary.withOpacity(0.6),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Enhanced subtitle
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 700),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accentSecondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🚀 ',
                      style: textTheme.titleLarge,
                    ),
                    Text(
                      'My professional journey in code',
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.accentSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' 💻',
                      style: textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildExperienceCards(TextTheme textTheme) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: Column(
        children: _experiences.asMap().entries.map((entry) {
          final index = entry.key;
          final experience = entry.value;
          
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = _controller.value - (index * 0.2);
              final offset = delay < 0 ? 50.0 : 0.0;
              final opacity = delay < 0 ? 0.0 : 1.0;
              
              return Transform.translate(
                offset: Offset(offset, 0),
                child: Opacity(
                  opacity: opacity,
                  child: child,
                ),
              );
            },
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredCardIndex = index),
              onExit: (_) => setState(() => _hoveredCardIndex = null),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => context.go('/experience'),
                child: _buildEnhancedCard(experience, index, textTheme),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEnhancedCard(Map<String, dynamic> experience, int index, TextTheme textTheme) {
    final isHovered = _hoveredCardIndex == index;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: experience['color'].withOpacity(isHovered ? 0.25 : 0.1),
            blurRadius: isHovered ? 25 : 15,
            offset: isHovered ? const Offset(0, 12) : const Offset(0, 8),
            spreadRadius: isHovered ? 2 : 0,
          ),
        ],
      ),
      transform: isHovered 
          ? (Matrix4.identity()..translate(0.0, -8.0)..scale(1.02)) 
          : Matrix4.identity(),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isHovered ? AppColors.cardHover : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: experience['color'].withOpacity(isHovered ? 0.5 : 0.2),
            width: isHovered ? 2 : 1,
          ),
          gradient: isHovered ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.cardBackground,
              experience['color'].withOpacity(0.05),
            ],
          ) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with enhanced styling
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isHovered ? 50 : 45,
                  height: isHovered ? 50 : 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        experience['color'],
                        experience['color'].withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: experience['color'].withOpacity(0.3),
                        blurRadius: isHovered ? 15 : 10,
                        spreadRadius: isHovered ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    experience['icon'],
                    color: Colors.white,
                    size: isHovered ? 22 : 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              experience['company'],
                              style: textTheme.titleLarge?.copyWith(
                                color: experience['color'],
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.symmetric(
                              horizontal: isHovered ? 14 : 12, 
                              vertical: isHovered ? 8 : 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  experience['color'].withOpacity(0.2),
                                  experience['color'].withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: experience['color'].withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: experience['color'],
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  experience['period'],
                                  style: TextStyle(
                                    color: experience['color'],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        experience['position'],
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              experience['description'],
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            
            // Tech stack badges
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (experience['techStack'] as List<String>).map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: experience['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: experience['color'].withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tech,
                    style: TextStyle(
                      color: experience['color'],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            // Achievements section (only show on hover)
            if (isHovered) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: experience['color'].withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: experience['color'].withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.military_tech,
                          color: experience['color'],
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Key Achievements',
                          style: TextStyle(
                            color: experience['color'],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      math.min(2, (experience['achievements'] as List).length), // Limit to 2 achievements to prevent overflow
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: experience['color'],
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                experience['achievements'][i],
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Click to explore more →',
                        style: TextStyle(
                          color: experience['color'],
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildExperienceAnimation() {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * _controller.value),
            child: child,
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated circle background
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 200 + 50 * _pulseController.value,
                  height: 200 + 50 * _pulseController.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentPrimary.withOpacity(0.1),
                        AppColors.accentPrimary.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Main animation
            Container(
              width: 250,
              height: 250,
              child: Lottie.network(
                Assets.workAnimation,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedButton() {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1200),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentPrimary.withOpacity(0.3 + 0.2 * _pulseController.value),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => context.go('/experience'),
              icon: const FaIcon(FontAwesomeIcons.code, size: 18),
              label: const Text('View Full Experience'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom painter for animated code matrix background
class CodeMatrixPainter extends CustomPainter {
  final Animation<double> animation;
  final List<String> chars;
  final math.Random random = math.Random();
  
  CodeMatrixPainter(this.animation, this.chars) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (int i = 0; i < 20; i++) {
      final x = (i * 60.0) % size.width;
      final y = (animation.value * size.height * 1.5 + i * 80) % (size.height + 200);
      
      for (int j = 0; j < 3; j++) {
        final charY = y - j * 30;
        if (charY > -30 && charY < size.height + 30) {
          final opacity = (1.0 - j * 0.3).clamp(0.0, 1.0);
          paint.color = AppColors.accentSecondary.withOpacity(opacity * 0.1);
          
          final textPainter = TextPainter(
            text: TextSpan(
              text: chars[random.nextInt(chars.length)],
              style: TextStyle(
                color: paint.color,
                fontSize: 14,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w300,
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