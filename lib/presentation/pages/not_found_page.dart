import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/assets.dart';
import 'package:lottie/lottie.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageScaffold(
      showFooter: false,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.network(
                  Assets.notFoundAnimation,
                  height: 220,
                ),
                const SizedBox(height: 24),
                Text(
                  '404',
                  style: textTheme.displayMedium?.copyWith(
                    color: AppColors.accentPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text('Page not found', style: textTheme.headlineSmall),
                const SizedBox(height: 32),
                AnimatedButton(
                  onPressed: () => context.go('/'),
                  text: 'Back to Home',
                  isPrimary: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
