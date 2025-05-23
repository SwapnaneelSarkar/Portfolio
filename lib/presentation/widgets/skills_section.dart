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

class _SkillsSectionState extends State<SkillsSection> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _radarController;
  late final AnimationController _codeController;
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = false;
  int? _hoveredSkillIndex;
  int? _hoveredCategoryIndex;
  
  final List<Map<String, dynamic>> _programmingSkills = [
    {
      'name': 'C++', 
      'status': 'Mastered',
      'color': AppColors.accentPrimary,
      'tags': ['Data Structures', 'Algorithms', 'OOP'],
      'icon': FontAwesomeIcons.code,
      'experience': '3+ years',
      'ecosystem': ['STL', 'Boost', 'CMake'],
    },
    {
      'name': 'C', 
      'status': 'Proficient',
      'color': AppColors.accentSecondary,
      'tags': ['Memory Management', 'System Programming'],
      'icon': FontAwesomeIcons.microchip,
      'experience': '2+ years',
      'ecosystem': ['GCC', 'Make', 'Embedded'],
    },
    {
      'name': 'Dart', 
      'status': 'Mastered',
      'color': AppColors.accentPrimary,
      'tags': ['Flutter', 'Async Programming', 'UI'],
      'icon': FontAwesomeIcons.at,
      'experience': '2+ years',
      'ecosystem': ['Flutter', 'Pub', 'DartPad'],
    },
    {
      'name': 'SQL', 
      'status': 'Proficient',
      'color': AppColors.accentSecondary,
      'tags': ['Database Design', 'Queries', 'Optimization'],
      'icon': FontAwesomeIcons.database,
      'experience': '2+ years',
      'ecosystem': ['MySQL', 'PostgreSQL', 'Firebase'],
    },
    {
      'name': 'Go', 
      'status': 'Learning',
      'color': AppColors.accentTertiary,
      'tags': ['Backend', 'Concurrency', 'APIs'],
      'icon': FontAwesomeIcons.golang,
      'experience': '1+ year',
      'ecosystem': ['Gin', 'Gorilla', 'gRPC'],
    },
    {
      'name': 'JavaScript', 
      'status': 'Active',
      'color': AppColors.accentSecondary,
      'tags': ['Web', 'DOM', 'Async'],
      'icon': FontAwesomeIcons.js,
      'experience': '1+ year',
      'ecosystem': ['Node.js', 'React', 'Express'],
    },
  ];
  
  final List<Map<String, dynamic>> _conceptSkills = [
    {
      'name': 'Data Structures & Algorithms', 
      'status': 'Mastered',
      'color': AppColors.accentPrimary,
      'tags': ['Problem Solving', 'Optimization', 'Complexity Analysis'],
      'icon': FontAwesomeIcons.sitemap,
      'experience': '3+ years',
      'ecosystem': ['LeetCode', 'Competitive Programming', 'System Design'],
    },
    {
      'name': 'Object-Oriented Programming', 
      'status': 'Mastered',
      'color': AppColors.accentSecondary,
      'tags': ['Design Patterns', 'SOLID Principles', 'Clean Code'],
      'icon': FontAwesomeIcons.cubes,
      'experience': '3+ years',
      'ecosystem': ['UML', 'Design Patterns', 'Architecture'],
    },
    {
      'name': 'Database Management', 
      'status': 'Proficient',
      'color': AppColors.accentPrimary,
      'tags': ['SQL', 'NoSQL', 'Firebase'],
      'icon': FontAwesomeIcons.server,
      'experience': '2+ years',
      'ecosystem': ['RDBMS', 'Document DB', 'Cloud DB'],
    },
    {
      'name': 'Algorithm Design & Analysis', 
      'status': 'Proficient',
      'color': AppColors.accentSecondary,
      'tags': ['Time Complexity', 'Space Complexity', 'Optimization'],
      'icon': FontAwesomeIcons.chartLine,
      'experience': '2+ years',
      'ecosystem': ['Dynamic Programming', 'Greedy', 'Divide & Conquer'],
    },
    {
      'name': 'Operating Systems', 
      'status': 'Active',
      'color': AppColors.accentTertiary,
      'tags': ['Process Management', 'Memory Management', 'File Systems'],
      'icon': FontAwesomeIcons.desktop,
      'experience': '2+ years',
      'ecosystem': ['Linux', 'Windows', 'System Calls'],
    },
    {
      'name': 'Software Engineering', 
      'status': 'Mastered',
      'color': AppColors.accentSecondary,
      'tags': ['SDLC', 'Agile', 'Testing'],
      'icon': FontAwesomeIcons.gear,
      'experience': '2+ years',
      'ecosystem': ['Git', 'CI/CD', 'Code Review'],
    },
  ];
  
  final List<Map<String, dynamic>> _techSkills = [
    {
      'name': 'Flutter', 
      'status': 'Mastered',
      'color': AppColors.accentPrimary,
      'tags': ['UI/UX', 'State Management', 'Animations'],
      'icon': FontAwesomeIcons.mobile,
      'experience': '2+ years',
      'ecosystem': ['BLoC', 'Provider', 'GetX'],
    },
    {
      'name': 'Arduino', 
      'status': 'Proficient',
      'color': AppColors.accentSecondary,
      'tags': ['IoT', 'Sensors', 'Embedded Systems'],
      'icon': FontAwesomeIcons.microchip,
      'experience': '2+ years',
      'ecosystem': ['ESP32', 'Raspberry Pi', 'Sensors'],
    },
    {
      'name': 'Firebase', 
      'status': 'Mastered',
      'color': AppColors.accentPrimary,
      'tags': ['Firestore', 'Authentication', 'Cloud Functions'],
      'icon': FontAwesomeIcons.fire,
      'experience': '2+ years',
      'ecosystem': ['Firestore', 'Auth', 'Hosting'],
    },
    {
      'name': 'Git & GitHub', 
      'status': 'Proficient',
      'color': AppColors.accentSecondary,
      'tags': ['Version Control', 'Collaboration', 'CI/CD'],
      'icon': FontAwesomeIcons.github,
      'experience': '3+ years',
      'ecosystem': ['GitHub Actions', 'GitLab', 'Branching'],
    },
    {
      'name': 'React.js', 
      'status': 'Learning',
      'color': AppColors.accentTertiary,
      'tags': ['Hooks', 'Components', 'State Management'],
      'icon': FontAwesomeIcons.react,
      'experience': '1+ year',
      'ecosystem': ['Redux', 'Next.js', 'TypeScript'],
    },
  ];

  final List<String> _codeSnippets = [
    'class', 'function', 'async', 'await', 'return', 'if', 'else',
    'for', 'while', 'const', 'var', 'let', 'import', 'export',
    '{', '}', '[]', '()', '=>', '&&', '||', '==', '!=', '++', '--',
  ];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _codeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
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
    _radarController.dispose();
    _codeController.dispose();
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
      child: Stack(
        children: [
          // Animated code background
          CustomPaint(
            painter: CodeRainPainter(_codeController, _codeSnippets),
            size: size,
          ),
          
          Column(
            children: [
              // Enhanced header
              _buildEnhancedHeader(textTheme),
              const SizedBox(height: 40),
              
              // Tech stack highlight with enhanced design
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: _buildEnhancedTechStackHighlight(textTheme, isMobile),
              ),
              const SizedBox(height: 60),
              
              // Skills categories with radar chart design
              _buildSkillsRadarView(textTheme, isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(TextTheme textTheme) {
    return Column(
      children: [
        // Binary code for "Skills"
        AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            '01010011 01101011 01101001 01101100 01101100 01110011',
            style: TextStyle(
              color: AppColors.accentSecondary.withOpacity(0.4),
              fontSize: 12,
              fontFamily: 'monospace',
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Main title with tech elements
        AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _radarController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _radarController.value * 2 * math.pi,
                    child: FaIcon(
                      FontAwesomeIcons.gear,
                      color: AppColors.accentPrimary,
                      size: 28,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Text(
                'My Skills',
                style: textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accentPrimary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'v2.0',
                  style: TextStyle(
                    color: AppColors.accentPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
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
            child: Text(
              '⚡ Expertise that drives innovation 🚀',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.accentSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEnhancedTechStackHighlight(TextTheme textTheme, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBackground,
            AppColors.cardBackground.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPrimary.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.rocket,
                color: AppColors.accentPrimary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Primary Tech Stack',
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.accentPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          isMobile
              ? Column(
                  children: [
                    _buildEnhancedTechStackItem(
                      'Flutter',
                      'Cross-platform UI toolkit',
                      Assets.flutterAnimation,
                      AppColors.accentPrimary,
                    ),
                    const SizedBox(height: 20),
                    _buildEnhancedTechStackItem(
                      'Go',
                      'Efficient backend language',
                      Assets.goAnimation,
                      AppColors.accentSecondary,
                    ),
                    const SizedBox(height: 20),
                    _buildEnhancedTechStackItem1(
                      'Firebase',
                      'Google\'s app development platform',
                      Assets.googleAnimation,
                      AppColors.accentTertiary,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildEnhancedTechStackItem(
                        'Flutter',
                        'Cross-platform UI toolkit',
                        Assets.flutterAnimation,
                        AppColors.accentPrimary,
                      ),
                    ),
                    Expanded(
                      child: _buildEnhancedTechStackItem(
                        'Go',
                        'Efficient backend language',
                        Assets.goAnimation,
                        AppColors.accentSecondary,
                      ),
                    ),
                    Expanded(
                      child: _buildEnhancedTechStackItem1(
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
  
  Widget _buildEnhancedTechStackItem(String title, String description, String animationUrl, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 80,
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Status indicator instead of skill bar
          _buildStatusIndicator('Primary Stack', color),
        ],
      ),
    );
  }
  
  Widget _buildEnhancedTechStackItem1(String title, String description, String animationUrl, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 80,
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Status indicator instead of skill bar
          _buildStatusIndicator('Primary Stack', color),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSkillsRadarView(TextTheme textTheme, bool isMobile) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: isMobile
          ? Column(
              children: [
                _buildSkillCategory(
                  'Programming Languages',
                  _programmingSkills,
                  textTheme,
                  0,
                  FontAwesomeIcons.code,
                ),
                const SizedBox(height: 30),
                _buildSkillCategory(
                  'Core Concepts',
                  _conceptSkills,
                  textTheme,
                  1,
                  FontAwesomeIcons.brain,
                ),
                const SizedBox(height: 30),
                _buildSkillCategory(
                  'Technologies & Tools',
                  _techSkills,
                  textTheme,
                  2,
                  FontAwesomeIcons.toolbox,
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
                    FontAwesomeIcons.code,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildSkillCategory(
                    'Core Concepts',
                    _conceptSkills,
                    textTheme,
                    1,
                    FontAwesomeIcons.brain,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildSkillCategory(
                    'Technologies & Tools',
                    _techSkills,
                    textTheme,
                    2,
                    FontAwesomeIcons.toolbox,
                  ),
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
    IconData categoryIcon,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredCategoryIndex = delayFactor),
      onExit: (_) => setState(() => _hoveredCategoryIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _hoveredCategoryIndex == delayFactor
                ? [
                    AppColors.cardBackground,
                    AppColors.cardHover,
                  ]
                : [
                    AppColors.cardBackground,
                    AppColors.cardBackground.withOpacity(0.8),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hoveredCategoryIndex == delayFactor
                ? AppColors.accentPrimary.withOpacity(0.5)
                : AppColors.accentPrimary.withOpacity(0.2),
            width: _hoveredCategoryIndex == delayFactor ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hoveredCategoryIndex == delayFactor ? 0.15 : 0.1),
              blurRadius: _hoveredCategoryIndex == delayFactor ? 20 : 15,
              offset: _hoveredCategoryIndex == delayFactor 
                  ? const Offset(0, 10) 
                  : const Offset(0, 5),
            ),
          ],
        ),
        transform: _hoveredCategoryIndex == delayFactor
            ? (Matrix4.identity()..scale(1.02)..translate(0.0, -5.0))
            : Matrix4.identity(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentPrimary,
                        AppColors.accentPrimary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentPrimary.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: FaIcon(
                    categoryIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.accentPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Skills list
            ...skills.asMap().entries.map((entry) {
              final index = entry.key;
              final skill = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildEnhancedSkillItem(
                  skill,
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
  
  Widget _buildEnhancedSkillItem(
    Map<String, dynamic> skill,
    int index,
    int delayFactor,
  ) {
    final globalIndex = delayFactor * 10 + index;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredSkillIndex = globalIndex),
      onExit: (_) => setState(() => _hoveredSkillIndex = null),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final delay = math.min(1.0, math.max(0.0, _controller.value * 2 - (index * 0.2 + delayFactor * 0.5)));
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: _hoveredSkillIndex == globalIndex
                ? (Matrix4.identity()..translate(10.0, 0.0))
                : Matrix4.identity(),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _hoveredSkillIndex == globalIndex
                        ? [
                            skill['color'].withOpacity(0.1),
                            skill['color'].withOpacity(0.05),
                          ]
                        : [
                            AppColors.backgroundDark.withOpacity(0.3),
                            AppColors.backgroundDark.withOpacity(0.1),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hoveredSkillIndex == globalIndex
                        ? skill['color'].withOpacity(0.5)
                        : skill['color'].withOpacity(0.2),
                    width: _hoveredSkillIndex == globalIndex ? 2 : 1,
                  ),
                  boxShadow: _hoveredSkillIndex == globalIndex
                      ? [
                          BoxShadow(
                            color: skill['color'].withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skill header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: skill['color'].withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FaIcon(
                            skill['icon'],
                            color: skill['color'],
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      skill['name'],
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildStatusBadge(skill['status'], skill['color']),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                skill['experience'],
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Ecosystem indicators instead of skill bar
                    _buildEcosystemIndicators(skill['ecosystem'], skill['color']),
                    const SizedBox(height: 12),
                    
                    // Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: (skill['tags'] as List<String>).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: skill['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: skill['color'].withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: skill['color'],
                              fontSize: 10,
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
      ),
    );
  }

  Widget _buildEcosystemIndicators(List<String> ecosystem, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.hub,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              'Ecosystem',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: ecosystem.map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                tech,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'monospace',
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    IconData statusIcon;
    Color statusColor = color;
    
    switch (status) {
      case 'Learning':
        statusIcon = Icons.trending_up;
        statusColor = AppColors.accentTertiary;
        break;
      case 'Active':
        statusIcon = Icons.flash_on;
        statusColor = AppColors.accentSecondary;
        break;
      case 'Proficient':
        statusIcon = Icons.verified;
        statusColor = AppColors.accentSecondary;
        break;
      case 'Mastered':
        statusIcon = Icons.military_tech;
        statusColor = AppColors.accentPrimary;
        break;
      default:
        statusIcon = Icons.code;
        statusColor = color;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.2),
            statusColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: statusColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for animated code rain background
class CodeRainPainter extends CustomPainter {
  final Animation<double> animation;
  final List<String> codeSnippets;
  final math.Random random = math.Random();
  
  CodeRainPainter(this.animation, this.codeSnippets) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (int i = 0; i < 25; i++) {
      final x = (i * 50.0) % size.width;
      final y = (animation.value * size.height * 1.5 + i * 100) % (size.height + 150);
      
      for (int j = 0; j < 2; j++) {
        final charY = y - j * 40;
        if (charY > -40 && charY < size.height + 40) {
          final opacity = (1.0 - j * 0.4).clamp(0.0, 1.0);
          paint.color = AppColors.accentSecondary.withOpacity(opacity * 0.08);
          
          final textPainter = TextPainter(
            text: TextSpan(
              text: codeSnippets[random.nextInt(codeSnippets.length)],
              style: TextStyle(
                color: paint.color,
                fontSize: 12,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w400,
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