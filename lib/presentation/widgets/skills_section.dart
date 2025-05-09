import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'dart:math' as math;
import 'package:portfolio/assets.dart';
import 'package:lottie/lottie.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({Key? key}) : super(key: key);

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = false;
  
  final List<Map<String, dynamic>> _programmingSkills = [
    {'name': 'C++', 'level': 0.85, 'color': AppColors.accentPrimary},
    {'name': 'C', 'level': 0.80, 'color': AppColors.accentSecondary},
    {'name': 'Dart', 'level': 0.90, 'color': AppColors.accentPrimary},
    {'name': 'SQL', 'level': 0.75, 'color': AppColors.accentSecondary},
    {'name': 'Go', 'level': 0.60, 'color': AppColors.accentPrimary},
    {'name': 'JavaScript', 'level': 0.70, 'color': AppColors.accentSecondary},
  ];
  
  final List<Map<String, dynamic>> _conceptSkills = [
    {'name': 'Data Structures & Algorithms', 'level': 0.85, 'color': AppColors.accentPrimary},
    {'name': 'Object-Oriented Programming', 'level': 0.90, 'color': AppColors.accentSecondary},
    {'name': 'Database Management', 'level': 0.75, 'color': AppColors.accentPrimary},
    {'name': 'Design & Analysis of Algorithms', 'level': 0.80, 'color': AppColors.accentSecondary},
    {'name': 'Operating Systems', 'level': 0.70, 'color': AppColors.accentPrimary},
    {'name': 'Software Engineering', 'level': 0.85, 'color': AppColors.accentSecondary},
  ];
  
  final List<Map<String, dynamic>> _techSkills = [
    {'name': 'Flutter', 'level': 0.90, 'color': AppColors.accentPrimary},
    {'name': 'Arduino', 'level': 0.75, 'color': AppColors.accentSecondary},
    {'name': 'Firebase', 'level': 0.85, 'color': AppColors.accentPrimary},
    {'name': 'Git & GitHub', 'level': 0.80, 'color': AppColors.accentSecondary},
    {'name': 'React.js', 'level': 0.65, 'color': AppColors.accentPrimary},
    {'name': 'Next.js', 'level': 0.60, 'color': AppColors.accentSecondary},
  ];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final isMobile = size.width < 768;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Section title
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              'My Skills',
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
              'Expertise that drives innovation',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.accentSecondary,
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Google-themed tech stack highlight
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accentPrimary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Google-Oriented Tech Stack',
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.accentPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  isMobile
                      ? Column(
                          children: [
                            _buildTechStackItem(
                              'Flutter',
                              'Cross-platform UI toolkit',
                              Assets.flutterAnimation,
                              AppColors.accentPrimary,
                            ),
                            const SizedBox(height: 20),
                            _buildTechStackItem(
                              'Go',
                              'Efficient backend language',
                              Assets.goAnimation,
                              AppColors.accentSecondary,
                            ),
                            const SizedBox(height: 20),
                            _buildTechStackItem1(
                              'Firebase',
                              'Google\'s app development platform',
                              Assets.googleAnimation,
                              AppColors.primaryLight,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: _buildTechStackItem(
                                'Flutter',
                                'Cross-platform UI toolkit',
                                Assets.flutterAnimation,
                                AppColors.accentPrimary,
                              ),
                            ),
                            Expanded(
                              child: _buildTechStackItem(
                                'Go',
                                'Efficient backend language',
                                Assets.goAnimation,
                                AppColors.accentSecondary,
                              ),
                            ),
                            Expanded(
                              child: _buildTechStackItem1(
                                'Firebase',
                                'Google\'s app development platform',
                                Assets.googleAnimation,
                                AppColors.accentTertiary,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
          
          // Skills categories
          isMobile
              ? Column(
                  children: [
                    _buildSkillCategory(
                      'Programming Languages',
                      _programmingSkills,
                      textTheme,
                      0,
                    ),
                    const SizedBox(height: 40),
                    _buildSkillCategory(
                      'Concepts',
                      _conceptSkills,
                      textTheme,
                      1,
                    ),
                    const SizedBox(height: 40),
                    _buildSkillCategory(
                      'Technologies',
                      _techSkills,
                      textTheme,
                      2,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSkillCategory(
                        'Programming Languages',
                        _programmingSkills,
                        textTheme,
                        0,
                      ),
                    ),
                    Expanded(
                      child: _buildSkillCategory(
                        'Concepts',
                        _conceptSkills,
                        textTheme,
                        1,
                      ),
                    ),
                    Expanded(
                      child: _buildSkillCategory(
                        'Technologies',
                        _techSkills,
                        textTheme,
                        2,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
  
  Widget _buildTechStackItem(String title, String description, String animationUrl, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Lottie.network(
              animationUrl,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildTechStackItem1(String title, String description, String animationUrl, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Lottie.asset(
              animationUrl,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSkillCategory(
    String title,
    List<Map<String, dynamic>> skills,
    TextTheme textTheme,
    int delayFactor,
  ) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000 + (delayFactor * 200)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.accentPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ...skills.map((skill) {
              final index = skills.indexOf(skill);
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildSkillBar(
                  skill['name'],
                  skill['level'],
                  skill['color'],
                  index,
                  delayFactor,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSkillBar(
    String name,
    double level,
    Color color,
    int index,
    int delayFactor,
  ) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = math.min(1.0, math.max(0.0, _controller.value * 2 - (index * 0.2 + delayFactor * 0.5)));
        final animatedLevel = level * delay;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(animatedLevel * 100).toInt()}%',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 8,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: constraints.maxWidth * animatedLevel,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.7)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          ],
        );
      },
    );
  }
}
