import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:portfolio/assets.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isVisible = false;
  
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
              'About Me',
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
              'Get to know me better',
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
                    _buildAboutContent(textTheme),
                    const SizedBox(height: 40),
                    _buildAboutAnimation(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildAboutContent(textTheme),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildAboutAnimation(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
  
  Widget _buildAboutContent(TextTheme textTheme) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who am I?',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.accentPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'I am a passionate Software Developer currently in my 3rd year of Computer Science and Business Systems at VIT AP University. With a strong foundation in C, C++, Data Structures, and Algorithms, I have specialized in Flutter, Dart, and Firebase development.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'My problem-solving skills and critical thinking abilities allow me to approach complex challenges with confidence. I am currently expanding my knowledge by learning GoLang for industry applications, focusing on Google-oriented technologies.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'I also work as a freelance Flutter developer, taking on projects that challenge me to create innovative solutions. With experience in Arduino programming and a passion for IoT, I am eager to explore its applications further.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildInfoItem(Icons.code, 'Flutter Developer'),
              _buildInfoItem(Icons.school, 'CS Student'),
              _buildInfoItem(Icons.work, 'Freelancer'),
              _buildInfoItem(Icons.location_on, 'Cooch Behar, India'),
              _buildInfoItem(Icons.email, 'swapnaneelsarkar571@gmail.com'),
            ],
          ),
          const SizedBox(height: 32),
          _buildResumeButton(),
        ],
      ),
    );
  }
  
  Widget _buildInfoItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.accentSecondary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildResumeButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Launch URL to download resume
        launchResumeDownload();
      },
      icon: const Icon(Icons.download),
      label: const Text('Download Resume'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  Widget _buildAboutAnimation() {
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
          Assets.codingAnimation,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
  
  void launchResumeDownload() async {
    // Implement URL launcher to download resume
    // This will be implemented in a utility function
  }
}
