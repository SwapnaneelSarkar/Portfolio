import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Left-aligned header: a mono eyebrow naming the section, then a display
/// headline saying what it's about. [large] is for the top of a page.
class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? description;
  final Color accent;
  final Widget? action;
  final bool large;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.description,
    this.accent = AppColors.marigold,
    this.action,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;
    final titleSize = large
        ? (isMobile ? 34.0 : 56.0)
        : (isMobile ? 26.0 : 38.0);

    final titles = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 2,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              eyebrow.toUpperCase(),
              style: AppText.mono(
                size: 12,
                weight: FontWeight.w600,
                color: accent,
                letterSpacing: 1.6,
              ),
            ),
          ],
        ),
        SizedBox(height: large ? 18 : 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: AppText.display(
                size: titleSize,
                weight: large ? FontWeight.w700 : FontWeight.w600,
                height: 1.12,
                letterSpacing: large ? -1.2 : -0.6,
              ),
            ),
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              description!,
              style: AppText.body(
                size: large ? 18 : 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: action == null || isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titles,
                if (action != null) ...[
                  const SizedBox(height: 20),
                  action!,
                ],
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: titles),
                const SizedBox(width: 24),
                action!,
              ],
            ),
    );
  }
}
