import 'package:flutter/material.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';
import 'package:portfolio/assets.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageScaffold(
      children: [
        const FadeInSection(
          child: SectionHeader(
            title: 'Projects',
            subtitle: 'What I have built and shipped',
          ),
        ),
        const SizedBox(height: 24),
        FadeInSection(
          delay: const Duration(milliseconds: 150),
          child: Center(
            child: Lottie.network(
              Assets.projectAnimation,
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Lottie.network(
                Assets.workAnimation,
                height: 160,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ContentContainer(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: PortfolioContent.projects.asMap().entries.map((entry) {
              final index = entry.key;
              final p = entry.value;
              return FadeInSection(
                delay: Duration(milliseconds: 200 + index * 100),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _ProjectDetailCard(project: p, textTheme: textTheme),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

String _projectLinkLabel(String url) {
  if (url.contains('apps.apple.com') || url.contains('play.google.com')) {
    return 'View on App Store';
  }
  if (url.contains('github.com')) {
    return 'View on GitHub';
  }
  return 'View project';
}

class _ProjectDetailCard extends StatelessWidget {
  final ProjectEntry project;
  final TextTheme textTheme;

  const _ProjectDetailCard({
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
            style: textTheme.headlineSmall?.copyWith(color: project.color),
          ),
          const SizedBox(height: 8),
          Text(
            '${project.role} · ${project.period}',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(project.description, style: textTheme.bodyLarge),
          const SizedBox(height: 20),
          Text('Highlights', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          ...project.highlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('— ', style: TextStyle(color: project.color)),
                  Expanded(child: Text(h, style: textTheme.bodyLarge)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.technologies
                .map((t) => TagChip(label: t, color: project.color))
                .toList(),
          ),
          if (project.projectUrl != null) ...[
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => launchUrl(
                Uri.parse(project.projectUrl!),
                mode: LaunchMode.externalApplication,
              ),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(_projectLinkLabel(project.projectUrl!)),
            ),
          ],
        ],
      ),
    );
  }
}
