import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'dart:math' as math;
import 'package:portfolio/assets.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    {
      'name': 'C++', 
      'level': 'Expert', 
      'color': AppColors.accentPrimary,
      'tags': ['Data Structures', 'Algorithms', 'OOP']
    },
    {
      'name': 'C', 
      'level': 'Advanced', 
      'color': AppColors.accentSecondary,
      'tags': ['Memory Management', 'System Programming']
    },
    {
      'name': 'Dart', 
      'level': 'Expert', 
      'color': AppColors.accentPrimary,
      'tags': ['Flutter', 'Async Programming', 'UI']
    },
    {
      'name': 'SQL', 
      'level': 'Advanced', 
      'color': AppColors.accentSecondary,
      'tags': ['Database Design', 'Queries', 'Optimization']
    },
    {
      'name': 'Go', 
      'level': 'Intermediate', 
      'color': AppColors.accentPrimary,
      'tags': ['Backend', 'Concurrency', 'APIs']
    },
    {
      'name': 'JavaScript', 
      'level': 'Intermediate', 
      'color': AppColors.accentSecondary,
      'tags': ['Web', 'DOM', 'Async']
    },
  ];
  
  final List<Map<String, dynamic>> _conceptSkills = [
    {
      'name': 'Data Structures & Algorithms', 
      'level': 'Expert', 
      'color': AppColors.accentPrimary,
      'tags': ['Problem Solving', 'Optimization', 'Complexity Analysis']
    },
    {
      'name': 'Object-Oriented Programming', 
      'level': 'Expert', 
      'color': AppColors.accentSecondary,
      'tags': ['Design Patterns', 'SOLID Principles', 'Clean Code']
    },
    {
      'name': 'Database Management', 
      'level': 'Advanced', 
      'color': AppColors.accentPrimary,
      'tags': ['SQL', 'NoSQL', 'Firebase']
    },
    {
      'name': 'Design & Analysis of Algorithms', 
      'level': 'Advanced', 
      'color': AppColors.accentSecondary,
      'tags': ['Time Complexity', 'Space Complexity', 'Optimization']
    },
    {
      'name': 'Operating Systems', 
      'level': 'Advanced', 
      'color': AppColors.accentPrimary,
      'tags': ['Process Management', 'Memory Management', 'File Systems']
    },
    {
      'name': 'Software Engineering', 
      'level': 'Expert', 
      'color': AppColors.accentSecondary,
      'tags': ['SDLC', 'Agile', 'Testing']
    },
  ];
  
  final List<Map<String, dynamic>> _techSkills = [
    {
      'name': 'Flutter', 
      'level': 'Expert', 
      'color': AppColors.accentPrimary,
      'tags': ['UI/UX', 'State Management', 'Animations']
    },
    {
      'name': 'Arduino', 
      'level': 'Advanced', 
      'color': AppColors.accentSecondary,
      'tags': ['IoT', 'Sensors', 'Embedded Systems']
    },
    {
      'name': 'Firebase', 
      'level': 'Expert', 
      'color': AppColors.accentPrimary,
      'tags': ['Firestore', 'Authentication', 'Cloud Functions']
    },
    {
      'name': 'Git & GitHub', 
      'level': 'Advanced', 
      'color': AppColors.accentSecondary,
      'tags': ['Version Control', 'Collaboration', 'CI/CD']
    },
    {
      'name': 'React.js', 
      'level': 'Intermediate', 
      'color': AppColors.accentPrimary,
      'tags': ['Hooks', 'Components', 'State Management']
    },
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
          
          // Tech stack highlight
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: _buildTechStackHighlight(textTheme, isMobile),
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
  
  Widget _buildTechStackHighlight(TextTheme textTheme, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPrimary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Tech Stack',
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
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
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
                child: _buildSkillItem(
                  skill['name'],
                  skill['level'],
                  skill['color'],
                  skill['tags'],
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
  
  Widget _buildSkillItem(
    String name,
    String level,
    Color color,
    List<String> tags,
    int index,
    int delayFactor,
  ) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = math.min(1.0, math.max(0.0, _controller.value * 2 - (index * 0.2 + delayFactor * 0.5)));
        
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(20 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
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
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildLevelBadge(level),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildLevelBadge(String level) {
    Color badgeColor;
    
    switch (level) {
      case 'Beginner':
        badgeColor = AppColors.beginnerLevel;
        break;
      case 'Intermediate':
        badgeColor = AppColors.intermediateLevel;
        break;
      case 'Advanced':
        badgeColor = AppColors.advancedLevel;
        break;
      case 'Expert':
        badgeColor = AppColors.expertLevel;
        break;
      default:
        badgeColor = AppColors.accentPrimary;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
