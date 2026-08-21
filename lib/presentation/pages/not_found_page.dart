import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageScaffold(
      showFooter: false,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.55,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: AppColors.primaryGradient,
                  ).createShader(bounds),
                  child: Text(
                    '404',
                    style: textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SIGNAL LOST',
                  style: AppFonts.mono(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 12),
                Text('Page not found', style: textTheme.headlineSmall),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AnimatedButton(
                      onPressed: () => context.go('/'),
                      text: 'Back to Home',
                      isPrimary: true,
                    ),
                    AnimatedButton(
                      onPressed: () => context.go('/projects'),
                      text: 'View Projects',
                      isPrimary: false,
                    ),
                    TextButton(
                      onPressed: () => context.go('/contact'),
                      child: const Text('or contact me'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
