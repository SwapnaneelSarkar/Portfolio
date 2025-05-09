import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/pages/snake_game_page.dart';
import 'package:portfolio/presentation/widgets/animated_text.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/assets.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  final AnimationController controller;
  
  const HeroSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          // Background animated elements
          Positioned(
            right: -100,
            top: size.height * 0.2,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    50 * (1 - controller.value),
                    0,
                  ),
                  child: Opacity(
                    opacity: controller.value,
                    child: child,
                  ),
                );
              },
//               child: Lottie.asset(
//   Assets.googleAnimation,
//   height: 400,
//   fit: BoxFit.contain,
// ),
            ),
          ),
          
          // Main content
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side - Text content
                Expanded(
                  flex: 3,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          -50 * (1 - controller.value),
                          0,
                        ),
                        child: Opacity(
                          opacity: controller.value,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting
                        Text(
                          'Hello, I am',
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.accentSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Name
                        Text(
                          'Swapnaneel Sarkar',
                          style: textTheme.displayMedium?.copyWith(
                            background: Paint()
                              ..shader = const LinearGradient(
                                colors: AppColors.primaryGradient,
                              ).createShader(
                                const Rect.fromLTWH(0, 0, 300, 70),
                              ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Animated roles
                        SizedBox(
                          height: 50,
                          child: DefaultTextStyle(
                            style: textTheme.headlineMedium!.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Software Developer',
                                  speed: const Duration(milliseconds: 100),
                                ),
                                TypewriterAnimatedText(
                                  'Flutter Developer',
                                  speed: const Duration(milliseconds: 100),
                                ),
                                TypewriterAnimatedText(
                                  'Freelancer',
                                  speed: const Duration(milliseconds: 100),
                                ),
                                TypewriterAnimatedText(
                                  'Problem Solver',
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                              repeatForever: true,
                              pause: const Duration(milliseconds: 1000),
                              displayFullTextOnTap: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Description
                        Text(
                          'Building beautiful, responsive applications with Flutter and solving complex problems with a passion for clean code. Specializing in Google-oriented technologies like Flutter and Go.',
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 40),
                        
                        // Call to action buttons
                        Row(
                          children: [
                            AnimatedButton(
                              onPressed: () => context.go('/projects'),
                              text: 'View Projects',
                              isPrimary: true,
                            ),
                            const SizedBox(width: 16),
                            AnimatedButton(
                              onPressed: () => context.go('/contact'),
                              text: 'Contact Me',
                              isPrimary: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Resume download button
                        OutlinedButton.icon(
                          onPressed: () => _launchUrl(Assets.resumeUrl),
                          icon: const Icon(Icons.download),
                          label: const Text('Download Resume'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accentPrimary,
                            side: const BorderSide(color: AppColors.accentPrimary, width: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Right side - Animated illustration
                if (size.width > 900)
                  Expanded(
                    flex: 2,
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            50 * (1 - controller.value),
                            0,
                          ),
                          child: Opacity(
                            opacity: controller.value,
                            child: child,
                          ),
                        );
                      },
                      child: Lottie.network(
                        Assets.developerAnimation,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Scroll down indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Scroll Down',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Lottie.network(
                    Assets.scrollDownAnimation,
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
          
          // Easter egg trigger (hidden in the corner)
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => _showEasterEgg(context),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showEasterEgg(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SnakeGamePage(),
      ),
    );
  }
  
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
