import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/project_card.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';

class ProjectsPreview extends StatelessWidget {
  const ProjectsPreview({super.key});

  /// Five cards plus the "see all" card fill two rows of three.
  static const _featured = 5;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return ContentContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Featured 0→1 builds',
            title: 'Products I\'ve shipped',
            accent: AppColors.shipped,
          ),
          SizedBox(height: isMobile ? 32 : 48),
          ResponsiveGrid(
            minCellWidth: 330,
            children: [
              ...PortfolioContent.projects
                  .take(_featured)
                  .map((p) => ProjectCard(project: p)),
              const _AllProjectsCard(),
            ],
          ),
        ],
      ),
    );
  }
}

/// Fills the last grid slot with a way into the full Projects page.
class _AllProjectsCard extends StatelessWidget {
  const _AllProjectsCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      accentColor: AppColors.shipped,
      semanticLabel: 'See all projects',
      onTap: () => context.go('/projects'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.shipped.withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.shipped,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'See all ${PortfolioContent.projects.length} projects',
              style: AppText.display(size: 19, weight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Highlights, full tech stacks, and links for every build.',
              style: AppText.body(size: 14.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
