import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';

/// The differentiator section: verticals with real shipped products.
class DomainExpertiseSection extends StatelessWidget {
  const DomainExpertiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final domains = PortfolioContent.domains;

    return ContentContainer(
      child: Column(
        children: [
          const SectionHeader(
            title: 'Where I\'ve Shipped',
            subtitle: 'Domain depth',
          ),
          const SizedBox(height: 16),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                'Most PMs my age have shipped a to-do app. I\'ve shipped procurement systems.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 48),
          if (isMobile)
            Column(
              children: [
                for (final d in domains)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _DomainCard(domain: d),
                  ),
              ],
            )
          else
            Column(
              children: [
                for (var row = 0; row < domains.length; row += 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _DomainCard(domain: domains[row])),
                        const SizedBox(width: 20),
                        Expanded(
                          child: row + 1 < domains.length
                              ? _DomainCard(domain: domains[row + 1])
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DomainCard extends StatelessWidget {
  final DomainEntry domain;

  const _DomainCard({required this.domain});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GlassCard(
      accentColor: domain.color,
      tilt: true,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: domain.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: domain.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(domain.icon, color: domain.color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(domain.title, style: textTheme.titleLarge),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            domain.description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in domain.tags)
                TagChip(label: tag, color: domain.color, emphasized: true),
            ],
          ),
        ],
      ),
    );
  }
}
