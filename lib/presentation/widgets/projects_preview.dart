import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/assets.dart';

class ProjectsPreview extends StatefulWidget {
  const ProjectsPreview({Key? key}) : super(key: key);

  @override
  State<ProjectsPreview> createState() => _ProjectsPreviewState();
}

class _ProjectsPreviewState extends State<ProjectsPreview> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isVisible = false;
  
  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'Grape',
      'description': 'A Flutter-based mobile app designed to help manage chronic illnesses. ',
      'technologies': ['Flutter', 'Firebase', 'WebRTC'],
      'color': AppColors.accentPrimary,
    },
    {
      'title': 'Asset Management System',
      'description': 'An IoT based asset management system. This uses a ESP-82 along with RFiD scanners and an mobile app to show the realtime output',
      'technologies': ['Flutter', 'Firebase', 'ESP-82'],
      'color': AppColors.accentSecondary,
    },
    {
      'title': 'Blog Explorer',
      'description': 'A Flutter application for exploring and reading blogs with a clean, modern UI and offline reading capabilities.',
      'technologies': ['Flutter', 'Firebase', 'BLoC'],
      'color': AppColors.accentTertiary,
    },
    {
      'title': 'Application Tracking System',
      'description': 'A system to track job applications with status updates, reminders, and analytics dashboard.',
      'technologies': ['Flutter', 'Firebase', 'ESP-82'],
      'color': AppColors.accentSecondary,
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
              'Projects',
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
              'Some of my recent work',
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
                    _buildProjectCards(textTheme, isMobile),
                    const SizedBox(height: 40),
                    _buildProjectAnimation(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildProjectAnimation(),
                    ),
                    Expanded(
                      flex: 3,
                      child: _buildProjectCards(textTheme, isMobile),
                    ),
                  ],
                ),
          
          // View more button
          const SizedBox(height: 40),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1200),
            child: AnimatedButton(
              onPressed: () => context.go('/projects'),
              text: 'View All Projects',
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProjectCards(TextTheme textTheme, bool isMobile) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: isMobile
          ? Column(
              children: _projects.map((project) {
                final index = _projects.indexOf(project);
                return _buildProjectCard(project, index, textTheme);
              }).toList(),
            )
          : GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
              children: _projects.map((project) {
                final index = _projects.indexOf(project);
                return _buildProjectCard(project, index, textTheme);
              }).toList(),
            ),
    );
  }
  
  Widget _buildProjectCard(Map<String, dynamic> project, int index, TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = _controller.value - (index * 0.2);
        final offset = delay < 0 ? 50.0 : 0.0;
        final opacity = delay < 0 ? 0.0 : 1.0;
        
        return Transform.translate(
          offset: Offset(0, offset),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: project['color'].withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
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
              style: textTheme.titleLarge?.copyWith(
                color: project['color'],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              project['description'],
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
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
    );
  }
  
  Widget _buildProjectAnimation() {
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
        child: Lottie.asset(
          Assets.projectAnimation,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
