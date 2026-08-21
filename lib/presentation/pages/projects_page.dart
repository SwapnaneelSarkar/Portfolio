import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final projects = PortfolioContent.projects;

    return PageScaffold(
      children: [
        const FadeInSection(
          child: SectionHeader(
            title: 'Products I\'ve Shipped',
            subtitle: 'Built · Launched · Iterated',
          ),
        ),
        const SizedBox(height: 16),
        FadeInSection(
          delay: const Duration(milliseconds: 100),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Each of these started as an ambiguous problem — I owned the product decisions, scoped the MVP, and shipped. ${projects.length} products, from AI voice platforms to developer tools.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        ContentContainer(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: projects.asMap().entries.map((entry) {
              final index = entry.key;
              final p = entry.value;
              return FadeInSection(
                delay: Duration(milliseconds: 80 * (index % 3)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _ProjectDetailCard(
                    project: p,
                    index: index,
                    textTheme: textTheme,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ProjectDetailCard extends StatelessWidget {
  final ProjectEntry project;
  final int index;
  final TextTheme textTheme;

  const _ProjectDetailCard({
    required this.project,
    required this.index,
    required this.textTheme,
  });

  bool get _primaryIsLive =>
      project.projectUrl != null &&
      !project.projectUrl!.contains('github.com') &&
      !project.projectUrl!.contains('apps.apple.com') &&
      !project.projectUrl!.contains('play.google.com');

  String get _primaryLabel {
    final url = project.projectUrl!;
    if (url.contains('apps.apple.com') || url.contains('play.google.com')) {
      return 'App Store';
    }
    if (url.contains('github.com')) return 'GitHub';
    return 'View Live';
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 700;

    return GlassCard(
      accentColor: AppColors.accentPrimary,
      padding: EdgeInsets.all(isNarrow ? 22 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '0${index + 1}',
                  style: AppFonts.mono(
                    fontSize: 13,
                    color: AppColors.accentSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title, style: textTheme.headlineSmall),
                    if (isNarrow) ...[
                      const SizedBox(height: 6),
                      Text(
                        project.period,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.accentPrimary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isNarrow)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Text(
                    project.period,
                    style: AppFonts.mono(
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppLayout.maxProseWidth),
            child: Text(
              project.description,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textBody,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'HIGHLIGHTS',
            style: AppFonts.mono(
              fontSize: 10.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppLayout.maxProseWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final h in project.highlights)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: 12,
                            height: 2,
                            decoration: BoxDecoration(
                              color: AppColors.accentPrimary
                                  .withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            h,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textBody,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                project.technologies.map((t) => TagChip(label: t)).toList(),
          ),
          if (project.projectUrl != null || project.githubUrl != null) ...[
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (project.projectUrl != null)
                  _LinkButton(
                    label: _primaryLabel,
                    icon: _primaryIsLive
                        ? Icons.rocket_launch_outlined
                        : Icons.open_in_new,
                    color: AppColors.accentPrimary,
                    filled: true,
                    url: project.projectUrl!,
                  ),
                if (project.githubUrl != null)
                  _LinkButton(
                    label: 'GitHub',
                    icon: Icons.code,
                    color: AppColors.accentPrimary,
                    filled: false,
                    url: project.githubUrl!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  final String url;

  const _LinkButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.filled,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    void open() => launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );

    // Secondary tier: neutral surface, accent reserved for the icon.
    return OutlinedButton.icon(
      onPressed: open,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: BorderSide(
          color: filled
              ? color.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.22),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      icon: Icon(icon, size: 17, color: filled ? color : null),
      label: Text(label),
    );
  }
}
