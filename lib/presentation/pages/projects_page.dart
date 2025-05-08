import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/custom_app_bar.dart';
import 'package:portfolio/presentation/widgets/footer.dart';
import 'package:portfolio/presentation/widgets/animated_background.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _contentController;
  bool _isVisible = false;
  
  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'Blog Explorer',
      'description': 'A Flutter application for exploring and reading blogs with a clean, modern UI and offline reading capabilities. Users can save articles for later, customize their reading experience, and receive notifications for new content.',
      'technologies': ['Flutter', 'Firebase', 'BLoC', 'REST API'],
      'features': [
        'Offline reading mode',
        'Personalized content recommendations',
        'Dark/Light theme toggle',
        'Bookmark and favorites system',
      ],
      'color': AppColors.accentPrimary,
      'animation': 'https://assets9.lottiefiles.com/packages/lf20_CTaizi.json',
    },
    {
      'title': 'Application Tracking System',
      'description': 'A comprehensive system to track job applications with status updates, reminders, and an analytics dashboard. Helps job seekers organize their applications and follow up on opportunities.',
      'technologies': ['Flutter', 'Firebase', 'Cloud Functions', 'Charts'],
      'features': [
        'Application status tracking',
        'Automated reminders for follow-ups',
        'Analytics dashboard with insights',
        'Document storage for resumes and cover letters',
      ],
      'color': AppColors.accentSecondary,
      'animation': 'https://assets5.lottiefiles.com/packages/lf20_rqcjx9kc.json',
    },
    {
      'title': 'Grape',
      'description': 'A social media platform specifically designed for connecting professionals in the tech industry. Features include job postings, skill showcasing, and networking opportunities.',
      'technologies': ['Flutter', 'Firebase', 'WebRTC', 'Cloud Storage'],
      'features': [
        'Real-time messaging and video calls',
        'Job board with filtering options',
        'Skill endorsement system',
        'Event discovery and networking',
      ],
      'color': AppColors.accentTertiary,
      'animation': 'https://assets3.lottiefiles.com/packages/lf20_UgZWvP.json',
    },
    {
      'title': 'GradeBook',
      'description': 'An educational app that helps students track their grades, assignments, and academic progress throughout the semester. Includes features for setting goals and monitoring improvement.',
      'technologies': ['Flutter', 'SQLite', 'Provider', 'Notifications'],
      'features': [
        'Grade calculation and GPA tracking',
        'Assignment deadline reminders',
        'Progress visualization with charts',
        'Course schedule management',
      ],
      'color': AppColors.accentPrimary,
      'animation': 'https://assets8.lottiefiles.com/packages/lf20_DMgKk1.json',
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    
    // Add post-frame callback to start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isVisible = true;
      });
      _contentController.forward();
    });
  }
  
  @override
  void dispose() {
    _backgroundController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackground(controller: _backgroundController),
          
          // Main Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Header
                Container(
                  height: 300,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: _isVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            'My Projects',
                            style: textTheme.displayMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedOpacity(
                          opacity: _isVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 700),
                          child: SizedBox(
                            height: 50,
                            child: DefaultTextStyle(
                              style: textTheme.headlineSmall!.copyWith(
                                color: AppColors.accentSecondary,
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Showcasing my best work',
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                  TypewriterAnimatedText(
                                    'From concept to completion',
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                  TypewriterAnimatedText(
                                    'Building innovative solutions',
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                ],
                                repeatForever: true,
                                pause: const Duration(milliseconds: 1000),
                                displayFullTextOnTap: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Projects
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    children: _projects.map((project) {
                      final index = _projects.indexOf(project);
                      return _buildProjectCard(project, index, textTheme, size);
                    }).toList(),
                  ),
                ),
                
                // Footer
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProjectCard(Map<String, dynamic> project, int index, TextTheme textTheme, Size size) {
    final isMobile = size.width < 768;
    final isEven = index % 2 == 0;
    
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        final delay = _contentController.value - (index * 0.2);
        final offset = delay < 0 ? 100.0 : 0.0;
        final opacity = delay < 0 ? 0.0 : 1.0;
        
        return Transform.translate(
          offset: Offset(isEven ? -offset : offset, 0),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: isMobile
            ? Column(
                children: [
                  _buildProjectContent(project, textTheme),
                  const SizedBox(height: 30),
                  _buildProjectAnimation(project),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: isEven
                    ? [
                        Expanded(
                          flex: 3,
                          child: _buildProjectContent(project, textTheme),
                        ),
                        Expanded(
                          flex: 2,
                          child: _buildProjectAnimation(project),
                        ),
                      ]
                    : [
                        Expanded(
                          flex: 2,
                          child: _buildProjectAnimation(project),
                        ),
                        Expanded(
                          flex: 3,
                          child: _buildProjectContent(project, textTheme),
                        ),
                      ],
              ),
      ),
    );
  }
  
  Widget _buildProjectContent(Map<String, dynamic> project, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: project['color'].withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: project['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project['title'],
            style: textTheme.headlineMedium?.copyWith(
              color: project['color'],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            project['description'],
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Technologies',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.accentSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (project['technologies'] as List<String>).map((tech) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: project['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tech,
                  style: TextStyle(
                    color: project['color'],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Key Features',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.accentSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (project['features'] as List<String>).map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: project['color'],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProjectAnimation(Map<String, dynamic> project) {
    return Lottie.network(
      project['animation'],
      fit: BoxFit.contain,
    );
  }
}
