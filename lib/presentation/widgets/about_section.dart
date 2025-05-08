import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
            'My problem-solving skills and critical thinking abilities allow me to approach complex challenges with confidence. I am currently expanding my knowledge by learning GoLang for industry applications.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'With experience in Arduino programming and a passion for IoT, I am eager to explore its applications further and create innovative solutions that make a difference.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildInfoItem(Icons.code, 'Flutter Developer'),
              const SizedBox(width: 24),
              _buildInfoItem(Icons.school, 'CS Student'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoItem(Icons.location_on, 'Cooch Behar, India'),
              const SizedBox(width: 24),
              _buildInfoItem(Icons.email, 'swapnaneelsarkar571@gmail.com'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
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
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
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
          'https://assets3.lottiefiles.com/packages/lf20_v4isjbj5.json',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
