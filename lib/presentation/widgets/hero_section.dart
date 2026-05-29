import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/metric_card.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/assets.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  final AnimationController controller;

  const HeroSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final profile = PortfolioContent.profile;
    final isMobile = size.width < 900;
    final showLottie = size.width > 900;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: size.height * 0.9,
        minWidth: size.width,
      ),
      child: Stack(
        children: [
          Center(
            child: ContentContainer(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 24 : 48,
                120,
                isMobile ? 24 : 48,
                80,
              ),
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.value,
                    child: Transform.translate(
                      offset: Offset(0, 28 * (1 - controller.value)),
                      child: child,
                    ),
                  );
                },
                child: isMobile
                    ? _buildTextColumn(context, textTheme, profile)
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTextColumn(context, textTheme, profile),
                          ),
                          if (showLottie)
                            Expanded(
                              flex: 2,
                              child: Lottie.network(
                                Assets.workAnimation,
                                fit: BoxFit.contain,
                                height: 320,
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text('Scroll', style: textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Lottie.network(
                    Assets.scrollDownAnimation,
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextColumn(
    BuildContext context,
    TextTheme textTheme,
    ProfileInfo profile,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          profile.title,
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.accentPrimary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          style: textTheme.displayMedium?.copyWith(
            fontSize: isMobile ? 40 : 52,
            height: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: DefaultTextStyle(
            style: textTheme.titleLarge!.copyWith(
              color: AppColors.textSecondary,
            ),
            child: AnimatedTextKit(
              animatedTexts: profile.animatedRoles
                  .map(
                    (r) => FadeAnimatedText(
                      r,
                      duration: const Duration(milliseconds: 2200),
                    ),
                  )
                  .toList(),
              repeatForever: true,
              pause: const Duration(milliseconds: 800),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'I turn ambiguous briefs into shipped products — discovery, roadmaps, and delivery across AI, SaaS, and mobile.',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 17,
              height: 1.55,
            ),
          ),
        ),
        const SizedBox(height: 36),
        _buildMetrics(isMobile),
        const SizedBox(height: 36),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AnimatedButton(
              onPressed: () => context.go('/case-studies'),
              text: 'Case Studies',
              isPrimary: true,
            ),
            AnimatedButton(
              onPressed: () => context.go('/projects'),
              text: 'Projects',
              isPrimary: false,
            ),
            OutlinedButton(
              onPressed: () => _launchUrl(Assets.resumeUrl),
              child: const Text('Resume'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetrics(bool isMobile) {
    final metrics = PortfolioContent.impactMetrics;
    if (isMobile) {
      return Column(
        children: metrics
            .map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MetricCard(value: m.value, label: m.label),
              ),
            )
            .toList(),
      );
    }
    return Row(
      children: metrics
          .map(
            (m) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: MetricCard(value: m.value, label: m.label),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
