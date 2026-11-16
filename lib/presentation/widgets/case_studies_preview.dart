import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/case_study_card.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';

class CaseStudiesPreview extends StatelessWidget {
  const CaseStudiesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return ContentContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: 'Case studies',
            title: 'Product strategy and analysis',
            description:
                'Teardowns of real products. Each one opens as a full deck.',
            accent: AppColors.research,
            action: AnimatedButton(
              onPressed: () => context.go('/case-studies'),
              text: 'All case studies',
              isPrimary: false,
              icon: Icons.arrow_forward_rounded,
            ),
          ),
          SizedBox(height: isMobile ? 32 : 48),
          ResponsiveGrid(
            minCellWidth: 440,
            maxColumns: 2,
            children: PortfolioContent.caseStudies
                .map((s) => CaseStudyCard(study: s))
                .toList(),
          ),
        ],
      ),
    );
  }
}
