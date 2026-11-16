import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return ContentContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Skills',
            title: 'Product craft and technical execution',
          ),
          SizedBox(height: isMobile ? 32 : 48),
          ResponsiveGrid(
            minCellWidth: 420,
            maxColumns: 2,
            children: PortfolioContent.skillGroups
                .map((g) => _SkillGroupCard(group: g))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillGroupCard extends StatelessWidget {
  final SkillGroup group;

  const _SkillGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: group.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(group.icon, color: group.color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  group.name,
                  style: AppText.body(
                    size: 18,
                    weight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
              Text(
                group.skills.length.toString().padLeft(2, '0'),
                style: AppText.mono(size: 12, color: AppColors.textFaint),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.skills
                .map((s) => TagChip(label: s, color: group.color))
                .toList(),
          ),
        ],
      ),
    );
  }
}
