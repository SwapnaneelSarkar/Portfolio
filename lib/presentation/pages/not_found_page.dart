import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/status_pill.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return PageScaffold(
      showFooter: false,
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.62,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const StatusPill(label: 'Signal lost', color: AppColors.coral),
                  const SizedBox(height: 24),
                  Text(
                    '404',
                    style: AppText.display(
                      size: isMobile ? 96 : 160,
                      weight: FontWeight.w800,
                      letterSpacing: -6,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Page not found. It may have moved, or never shipped.',
                    textAlign: TextAlign.center,
                    style: AppText.body(size: 18, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      AnimatedButton(
                        onPressed: () => context.go('/'),
                        text: 'Back to home',
                        isPrimary: true,
                        trailingIcon: Icons.arrow_forward_rounded,
                      ),
                      AnimatedButton(
                        onPressed: () => context.go('/projects'),
                        text: 'View projects',
                        isPrimary: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
