import 'package:flutter/material.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/ui/page_body.dart';
import 'package:portfolio/presentation/widgets/case_study_tiles.dart';

class CaseStudiesPage extends StatelessWidget {
  const CaseStudiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageBody(
      children: [
        PageHeader(
          title: 'Case studies',
          description: 'Teardowns of Rapido and HitWicket, plus the AI quoting '
              'workflow I owned from research to prototype. Read the full '
              'analysis in each deck.',
        ),
        CaseStudyGrid(studies: PortfolioContent.caseStudies),
      ],
    );
  }
}
