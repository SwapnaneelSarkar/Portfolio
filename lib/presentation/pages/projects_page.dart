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
                  eyebrow: 'Projects · ${projects.length} shipped',
                  title: 'What I have built and shipped',
                  description:
                      'From AI developer tools to quick commerce and healthcare apps, each one taken from idea to release.',
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
  final gutter = AppLayout.gutter(width);
  return EdgeInsets.fromLTRB(gutter, 0, gutter, width < 700 ? 56 : 88);
}
