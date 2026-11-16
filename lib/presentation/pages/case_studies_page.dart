import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/case_study_card.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';

class CaseStudiesPage extends StatelessWidget {
  const CaseStudiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final gutter = AppLayout.gutter(width);

    return PageScaffold(
      children: [
        ContentContainer(
          padding: EdgeInsets.fromLTRB(gutter, 0, gutter, width < 700 ? 56 : 88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FadeInSection(
                child: SectionHeader(
                  eyebrow: 'Case studies',
                  title: 'Product strategy, taken apart',
                  description:
                      'How real products grow, where their models crack, and what I would do next. Each study opens as a full deck.',
                  accent: AppColors.research,
                  large: true,
                ),
              ),
              const SizedBox(height: 56),
              ...PortfolioContent.caseStudies.asMap().entries.map((entry) {
                return FadeInSection(
                  delay: Duration(milliseconds: 150 + entry.key * 120),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: CaseStudyCard(study: entry.value, detailed: true),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
