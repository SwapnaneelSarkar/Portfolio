import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/case_study_card.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';

class CaseStudyDetailPage extends StatelessWidget {
  final String slug;

  const CaseStudyDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final study = PortfolioContent.caseStudyBySlug(slug);
    final gutter = AppLayout.gutter(context);

    final back = TextButton.icon(
      onPressed: () => context.go('/case-studies'),
      icon: const Icon(Icons.arrow_back_rounded, size: 18),
      label: const Text('All case studies'),
    );

    return PageScaffold(
      children: [
        ContentContainer(
          padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 88),
          child: FadeInSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                back,
                const SizedBox(height: 20),
                if (study == null)
                  Text(
                    'This case study doesn\'t exist. Pick one from the list instead.',
                    style: AppText.display(size: 24, weight: FontWeight.w600),
                  )
                else
                  CaseStudyCard(study: study, detailed: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
