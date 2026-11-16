import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/experience_card.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';

class ExperiencePreview extends StatelessWidget {
  const ExperiencePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final preview = PortfolioContent.experiences.take(2).toList();
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return ContentContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: 'Experience',
            title: 'Discovery to launch across clients and products',
            accent: AppColors.now,
            action: AnimatedButton(
              onPressed: () => context.go('/experience'),
              text: 'Full experience',
              isPrimary: false,
              icon: Icons.arrow_forward_rounded,
            ),
          ),
          SizedBox(height: isMobile ? 36 : 56),
          ExperienceTimeline(entries: preview, continues: true),
        ],
      ),
    );
  }
}
