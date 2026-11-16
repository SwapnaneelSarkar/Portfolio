import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/status_pill.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';
import 'package:url_launcher/url_launcher.dart';

/// Case study card in the "research" lilac. Opens the hosted deck.
class CaseStudyCard extends StatelessWidget {
  final CaseStudyEntry study;
  final bool detailed;

  const CaseStudyCard({
    super.key,
    required this.study,
    this.detailed = false,
  });

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 600;

    return GlassCard(
      accentColor: AppColors.research,
      padding: EdgeInsets.all(detailed && !isNarrow ? 32 : 26),
      semanticLabel: '${study.title} case study',
      onTap: () => launchUrl(
        Uri.parse(study.externalUrl),
        mode: LaunchMode.externalApplication,
      ),
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
                    const StatusPill(
                      label: 'Case study',
                      color: AppColors.research,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      study.title,
                      style: AppText.display(
                        size: detailed ? 30 : 24,
                        weight: FontWeight.w700,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      study.subtitle,
                      style: AppText.body(
                        size: 14.5,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _LogoTile(path: study.logoPath, height: isNarrow ? 60 : 80),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            study.summary,
            maxLines: detailed ? null : 4,
            overflow: detailed ? null : TextOverflow.ellipsis,
            style: AppText.body(
              size: detailed ? 16 : 15,
              color: detailed ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: study.tags.map((t) => TagChip(label: t)).toList(),
          ),
          if (!detailed) const Spacer(),
          const SizedBox(height: 22),
          Row(
            children: [
              Text(
                'Read full case study',
                style: AppText.body(
                  size: 14.5,
                  weight: FontWeight.w600,
                  color: AppColors.research,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.north_east_rounded,
                size: 15,
                color: AppColors.research,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Logos are dark-on-transparent, so they sit on a light tile.
class _LogoTile extends StatelessWidget {
  final String path;
  final double height;

  const _LogoTile({required this.path, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height * 1.5,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: height * 0.1,
        vertical: height * 0.06,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3FF),
        borderRadius: BorderRadius.circular(height * 0.28),
      ),
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}
