import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';

class ProjectsPreview extends StatefulWidget {
  const ProjectsPreview({super.key});

  @override
  State<ProjectsPreview> createState() => _ProjectsPreviewState();
}

class _ProjectsPreviewState extends State<ProjectsPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMobile = MediaQuery.of(context).size.width < 768;
    final items = PortfolioContent.projects;

    return FadeTransition(
      opacity: _controller,
      child: ContentContainer(
      child: Column(
        children: [
          const SectionHeader(
            title: 'Projects',
            subtitle: 'Products built and shipped',
          ),
          const SizedBox(height: 40),
          if (isMobile)
            ...items.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ProjectCard(project: p, textTheme: textTheme),
                ))
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map(
                    (p) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _ProjectCard(project: p, textTheme: textTheme),
                      ),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 32),
          AnimatedButton(
            onPressed: () => context.go('/projects'),
            text: 'View All Projects',
            isPrimary: false,
          ),
        ],
      ),
    ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectEntry project;
  final TextTheme textTheme;

  const _ProjectCard({
    required this.project,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      accentColor: project.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: textTheme.titleLarge?.copyWith(color: project.color),
          ),
          const SizedBox(height: 6),
          Text(
            '${project.role} · ${project.period}',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            project.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyLarge?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: project.technologies
                .take(3)
                .map((t) => TagChip(label: t, color: project.color))
                .toList(),
          ),
          if (project.projectUrl != null) ...[
            const SizedBox(height: 12),
            Text(
              project.projectUrl!.contains('github.com')
                  ? 'GitHub →'
                  : 'App Store →',
              style: textTheme.labelLarge?.copyWith(
                color: project.color,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
