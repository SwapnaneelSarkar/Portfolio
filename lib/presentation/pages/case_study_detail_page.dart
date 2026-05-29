import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/fade_in_section.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/page_scaffold.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';
import 'package:url_launcher/url_launcher.dart';

class CaseStudyDetailPage extends StatelessWidget {
  final String slug;

  const CaseStudyDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final study = PortfolioContent.caseStudyBySlug(slug);
    final textTheme = Theme.of(context).textTheme;

    if (study == null) {
      return PageScaffold(
        children: [
          Center(
            child: Column(
              children: [
                Text('Case study not found', style: textTheme.headlineSmall),
                TextButton(
                  onPressed: () => context.go('/case-studies'),
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return PageScaffold(
      children: [
        FadeInSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => context.go('/case-studies'),
                child: const Text('← Case studies'),
              ),
              const SizedBox(height: 16),
              GlassCard(
                accentColor: study.color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      study.title,
                      style: textTheme.displaySmall?.copyWith(
                        color: study.color,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(study.subtitle, style: textTheme.titleMedium),
                    const SizedBox(height: 20),
                    Text(study.summary, style: textTheme.bodyLarge),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: study.tags
                          .map((t) => TagChip(label: t, color: study.color))
                          .toList(),
                    ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: () => launchUrl(
                        Uri.parse(study.externalUrl),
                        mode: LaunchMode.externalApplication,
                      ),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Read full case study'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
