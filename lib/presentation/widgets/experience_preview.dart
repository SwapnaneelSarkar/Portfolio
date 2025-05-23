import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/assets.dart';

class ExperiencePreview extends StatefulWidget {
  const ExperiencePreview({Key? key}) : super(key: key);

  @override
  State<ExperiencePreview> createState() => _ExperiencePreviewState();
}

class _ExperiencePreviewState extends State<ExperiencePreview> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
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
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    
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
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final isMobile = size.width < 768;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          // Section title
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              'Experience',
              style: textTheme.displaySmall?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Section subtitle
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 700),
            child: Text(
              'My professional journey',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.accentSecondary,
              ),
            ),
          ),
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
          
          // View more button
          const SizedBox(height: 40),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1200),
            child: AnimatedButton(
              onPressed: () => context.go('/experience'),
              text: 'View Full Experience',
              isPrimary: true,
            ),
          ),
        ],
      ),
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _hoveredCardIndex == index 
                        ? AppColors.cardHover 
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: experience['color'].withOpacity(_hoveredCardIndex == index ? 0.2 : 0.1),
                        blurRadius: _hoveredCardIndex == index ? 15 : 10,
                        offset: _hoveredCardIndex == index 
                            ? const Offset(0, 8) 
                            : const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: experience['color'].withOpacity(_hoveredCardIndex == index ? 0.3 : 0.2),
                      width: 1,
                    ),
                  ),
                  transform: _hoveredCardIndex == index 
                      ? (Matrix4.identity()..translate(0.0, -5.0)) 
                      : Matrix4.identity(),
                  child: Stack(
                    children: [
                      // Main content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  experience['company'],
                                  style: textTheme.titleLarge?.copyWith(
                                    color: experience['color'],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: experience['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  experience['period'],
                                  style: TextStyle(
                                    color: experience['color'],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            experience['position'],
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            experience['description'],
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      
                      // Hover overlay
                      if (_hoveredCardIndex == index)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Key Responsibilities',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: experience['color'],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...List.generate(
                                    (experience['details'] as List).length,
                                    (i) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: experience['color'],
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              experience['details'][i],
                                              style: textTheme.bodyMedium?.copyWith(
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: Text(
                                      'Click to view more',
                                      style: TextStyle(
                                        color: experience['color'],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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
        child: Lottie.network(
          Assets.workAnimation,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
