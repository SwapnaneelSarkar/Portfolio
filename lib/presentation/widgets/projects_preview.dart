import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/animated_button.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final isMobile = MediaQuery.of(context).size.width < 900;
    final featured = PortfolioContent.projects.take(3).toList();
    final total = PortfolioContent.projects.length;

    return FadeTransition(
      opacity: _controller,
      child: ContentContainer(
        child: Column(
          children: [
            const SectionHeader(
              title: 'Products I\'ve Shipped',
              subtitle: 'Featured 0→1 builds',
            ),
            const SizedBox(height: 48),
            if (isMobile)
              ...featured.asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _ProjectCard(
                        project: e.value,
                        index: e.key,
                        textTheme: textTheme,
                        fillHeight: false,
                      ),
                    ),
                  )
            else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < featured.length; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: i == featured.length - 1 ? 0 : 16,
                          ),
                          child: _ProjectCard(
                            project: featured[i],
                            index: i,
                            textTheme: textTheme,
                            fillHeight: true,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 40),
            AnimatedButton(
              onPressed: () => context.go('/projects'),
              text: 'View All $total Products',
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
  final int index;
  final TextTheme textTheme;

  /// True when the card sits in a stretched row and can expand vertically.
  final bool fillHeight;

  const _ProjectCard({
    required this.project,
    required this.index,
    required this.textTheme,
    required this.fillHeight,
  });

  @override
  Widget build(BuildContext context) {
    final url = project.projectUrl;
    final description = Text(
      project.description,
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium,
    );

    return GlassCard(
      accentColor: AppColors.accentPrimary,
      tilt: true,
      onTap: url == null
          ? null
          : () => launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '0${index + 1}',
            style: AppFonts.mono(
              fontSize: 12,
              color: AppColors.accentSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(project.title, style: textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(project.period, style: textTheme.bodySmall),
          const SizedBox(height: 14),
          if (fillHeight) Expanded(child: description) else description,
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: project.technologies
                .take(3)
                .map((t) => TagChip(label: t))
                .toList(),
          ),
          if (url != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  url.contains('github.com')
                      ? 'VIEW ON GITHUB'
                      : (url.contains('apps.apple.com') ||
                              url.contains('play.google.com'))
                          ? 'ON THE APP STORE'
                          : 'VIEW LIVE',
                  style: AppFonts.mono(
                    fontSize: 10,
                    color: AppColors.accentPrimary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_outward,
                  size: 13,
                  color: AppColors.accentPrimary,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
