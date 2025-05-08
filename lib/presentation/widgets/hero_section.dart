import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/animated_text.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              child: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_w51pcehl.json',
                height: 400,
                fit: BoxFit.contain,
              ),
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
                          'Building beautiful, responsive applications with Flutter and solving complex problems with a passion for clean code.',
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
                        'https://assets9.lottiefiles.com/packages/lf20_w7401jcz.json',
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
                    'https://assets2.lottiefiles.com/packages/lf20_iikbn1ww.json',
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
