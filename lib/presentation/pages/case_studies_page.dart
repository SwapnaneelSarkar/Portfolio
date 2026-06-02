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

class CaseStudiesPage extends StatelessWidget {
  const CaseStudiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageScaffold(
      children: [
        const FadeInSection(
          child: SectionHeader(
            title: 'Case Studies',
            subtitle: 'Product strategy — read the full analysis on each site',
          ),
        ),
        const SizedBox(height: 24),
        FadeInSection(
          delay: const Duration(milliseconds: 150),
          child: Lottie.network(
            Assets.trackingAnimation,
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 32),
        ContentContainer(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: PortfolioContent.caseStudies.asMap().entries.map((entry) {
              final index = entry.key;
              final s = entry.value;
              return FadeInSection(
                delay: Duration(milliseconds: 250 + index * 120),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: GlassCard(
                    accentColor: s.color,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.title,
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: s.color,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(s.subtitle, style: textTheme.titleMedium),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Image.asset(
                              s.logoPath,
                              height: 48,
                              width: 120,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(s.summary, style: textTheme.bodyLarge),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: s.tags
                              .map((t) => TagChip(label: t, color: s.color))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () => launchUrl(
                            Uri.parse(s.externalUrl),
                            mode: LaunchMode.externalApplication,
                          ),
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: const Text('Open case study'),
                        ),
                      ],
                    ),
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
