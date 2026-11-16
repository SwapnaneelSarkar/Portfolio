import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/status_pill.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';
import 'package:url_launcher/url_launcher.dart';

String projectLinkLabel(String url) {
  if (url.contains('apps.apple.com')) return 'View on App Store';
  if (url.contains('play.google.com')) return 'View on Google Play';
  if (url.contains('github.com')) return 'View on GitHub';
  return 'Open live site';
}

/// Project as a shipped ticket. [detailed] adds highlights and the full
/// tech stack for the Projects page. Lives in a [ResponsiveGrid] cell, which
/// gives it a bounded height so the link can sit at the bottom.
class ProjectCard extends StatelessWidget {
  final ProjectEntry project;
  final bool detailed;

  const ProjectCard({
    super.key,
    required this.project,
    this.detailed = false,
  });

  @override
  Widget build(BuildContext context) {
    final url = project.projectUrl;
    final tech = detailed
        ? project.technologies
        : project.technologies.take(4).toList();

    return GlassCard(
      accentColor: AppColors.shipped,
      padding: EdgeInsets.all(detailed ? 30 : 24),
      semanticLabel: project.title,
      onTap: url == null
          ? null
          : () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const StatusPill(label: 'Shipped', color: AppColors.shipped),
              const Spacer(),
              Text(
                project.period,
                style: AppText.mono(size: 12, color: AppColors.textFaint),
              ),
            ],
          ),
          SizedBox(height: detailed ? 22 : 18),
          Text(
            project.title,
            style: AppText.display(
              size: detailed ? 26 : 19,
              weight: FontWeight.w600,
              height: 1.2,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            project.role,
            style: AppText.mono(size: 11.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          Text(
            project.description,
            maxLines: detailed ? null : 3,
            overflow: detailed ? null : TextOverflow.ellipsis,
            style: AppText.body(
              size: detailed ? 16 : 14.5,
              color: detailed ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          if (detailed) ...[
            const SizedBox(height: 20),
            ...project.highlights.map(
              (h) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: AppColors.shipped,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        h,
                        style: AppText.body(size: 15, height: 1.55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tech.map((t) => TagChip(label: t, mono: true)).toList(),
          ),
          const Spacer(),
          if (url != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  projectLinkLabel(url),
                  style: AppText.body(
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColors.shipped,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.north_east_rounded,
                  size: 15,
                  color: AppColors.shipped,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
