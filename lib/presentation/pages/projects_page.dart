import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/project_card.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioContent.projects;

    return PageScaffold(
      children: [
        ContentContainer(
          padding: _pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInSection(
                child: SectionHeader(
                  eyebrow: 'Built · Launched · Iterated',
                  title: 'Products I\'ve shipped',
                  description:
                      'Each of these started as an ambiguous problem — I owned the product decisions, scoped the MVP, and shipped. ${projects.length} products, from AI voice platforms to developer tools.',
                  accent: AppColors.shipped,
                  large: true,
                ),
              ),
              const SizedBox(height: 56),
              FadeInSection(
                delay: const Duration(milliseconds: 150),
                child: ResponsiveGrid(
                  minCellWidth: 480,
                  maxColumns: 2,
                  spacing: 24,
                  children: projects
                      .map((p) => ProjectCard(project: p, detailed: true))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

EdgeInsets _pagePadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  final gutter = AppLayout.gutter(context);
  return EdgeInsets.fromLTRB(gutter, 0, gutter, width < 700 ? 56 : 88);
}
