import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/assets.dart';

class ContactPreview extends StatefulWidget {
  const ContactPreview({Key? key}) : super(key: key);

  @override
  State<ContactPreview> createState() => _ContactPreviewState();
}

class _ContactPreviewState extends State<ContactPreview> with SingleTickerProviderStateMixin {
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
              'Get In Touch',
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
              'Let\'s work together',
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
                    _buildContactContent(textTheme),
                    const SizedBox(height: 40),
                    _buildContactAnimation(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildContactAnimation(),
                    ),
                    Expanded(
                      flex: 3,
                      child: _buildContactContent(textTheme),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
  
  Widget _buildContactContent(TextTheme textTheme) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interested in working together?',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.accentPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Whether you have a project in mind, a question about my work, or just want to say hello, I\'d love to hear from you. Let\'s create something amazing together!',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          _buildContactItem(
            Icons.email,
            'Email',
            'swapnaneelsarkar571@gmail.com',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            Icons.phone,
            'Phone',
            '+91 8967853033',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            Icons.location_on,
            'Location',
            'Hitendra Narayan Road, Cooch Behar- 736101',
          ),
          const SizedBox(height: 40),
          AnimatedButton(
            onPressed: () => context.go('/contact'),
            text: 'Contact Me',
            isPrimary: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.accentPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.accentPrimary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildContactAnimation() {
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
          Assets.contactAnimation,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
