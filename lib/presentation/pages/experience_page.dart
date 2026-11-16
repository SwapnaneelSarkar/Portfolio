import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/experience_card.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final gutter = AppLayout.gutter(context);
    final entries = PortfolioContent.experiences;

    return PageScaffold(
      children: [
        ContentContainer(
          padding: EdgeInsets.fromLTRB(gutter, 0, gutter, width < 700 ? 56 : 88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FadeInSection(
                child: SectionHeader(
                  eyebrow: 'Experience',
                  title: 'Roles, scope, and outcomes',
                  description:
                      'From building Flutter apps to owning discovery and delivery across 15+ client engagements.',
                  accent: AppColors.now,
                  large: true,
                ),
              ),
              const SizedBox(height: 64),
              for (var i = 0; i < entries.length; i++)
                FadeInSection(
                  delay: Duration(milliseconds: 120 + i * 80),
                  child: ExperienceCard(
                    experience: entries[i],
                    isLast: i == entries.length - 1,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
