import 'package:flutter/material.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/content_container.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/section_header.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({Key? key}) : super(key: key);

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final isMobile = size.width < 768;
    final groups = PortfolioContent.skillGroups;

    return ContentContainer(
      child: Column(
        children: [
          const SectionHeader(
            title: 'Skills',
            subtitle: 'Product craft and technical execution',
          ),
          const SizedBox(height: 48),
          isMobile
                ? Column(
                    children: groups
                        .map(
                          (g) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _SkillGroupCard(group: g, textTheme: textTheme),
                          ),
                        )
                        .toList(),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: groups
                        .map(
                          (g) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: _SkillGroupCard(group: g, textTheme: textTheme),
                            ),
                          ),
                        )
                        .toList(),
                  ),
        ],
      ),
    );
  }
}

class _SkillGroupCard extends StatelessWidget {
  final SkillGroup group;
  final TextTheme textTheme;

  const _SkillGroupCard({
    required this.group,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      accentColor: group.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(group.icon, color: group.color, size: 24),
              const SizedBox(width: 12),
              Text(
                group.name,
                style: textTheme.titleLarge?.copyWith(color: group.color),
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
