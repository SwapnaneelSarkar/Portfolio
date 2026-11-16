import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';

/// The differentiator section: verticals with real shipped products.
class DomainExpertiseSection extends StatelessWidget {
  const DomainExpertiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppLayout.isMobile(context);

    return ContentContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Domain depth',
            title: 'Where I\'ve shipped',
            description:
                'Most PMs my age have shipped a to-do app. I\'ve shipped procurement systems.',
          ),
          SizedBox(height: isMobile ? 32 : 48),
          ResponsiveGrid(
            minCellWidth: 440,
            maxColumns: 2,
            children: PortfolioContent.domains
                .map((d) => _DomainCard(domain: d))
                .toList(),
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
    return GlassCard(
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
                  color: domain.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(domain.icon, color: domain.color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  domain.title,
                  style: AppText.body(
                    size: 19,
                    weight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            domain.description,
            style: AppText.body(size: 15, color: AppColors.textBody),
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
