import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/status_pill.dart';
import 'package:portfolio/presentation/widgets/responsive_grid.dart';

/// Experience entries joined by a roadmap rail. The current role gets a
/// marigold node; past roles are hollow.
class ExperienceTimeline extends StatelessWidget {
  final List<ExperienceEntry> entries;

  /// True when the list continues on another page, so the rail fades out
  /// instead of ending.
  final bool continues;

  const ExperienceTimeline({
    super.key,
    required this.entries,
    this.continues = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < entries.length; i++)
          ExperienceCard(
            experience: entries[i],
            isLast: i == entries.length - 1 && !continues,
          ),
      ],
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final ExperienceEntry experience;
  final bool isLast;

  const ExperienceCard({
    super.key,
    required this.experience,
    this.isLast = false,
  });

  bool get isCurrent => experience.period.toLowerCase().contains('present');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 760;
    final nodeColor = isCurrent ? AppColors.now : AppColors.textFaint;

    final meta = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          experience.period,
          style: AppText.mono(
            size: 12,
            weight: FontWeight.w600,
            color: isCurrent ? AppColors.now : AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        if (experience.location.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            experience.location,
            style: AppText.mono(size: 11.5, color: AppColors.textFaint),
          ),
        ],
      ],
    );

    final content = Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNarrow) ...[meta, const SizedBox(height: 12)],
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                experience.company,
                style: AppText.display(
                  size: isNarrow ? 22 : 26,
                  weight: FontWeight.w700,
                  letterSpacing: -0.6,
                ),
              ),
              if (isCurrent)
                const StatusPill(label: 'Now', color: AppColors.now, pulse: true),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            experience.position,
            style: AppText.body(
              size: 16,
              weight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              experience.description,
              style: AppText.body(size: 16, height: 1.65),
            ),
          ),
          const SizedBox(height: 18),
          ...experience.responsibilities.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: 10,
                        height: 2,
                        color: isCurrent
                            ? AppColors.now.withValues(alpha: 0.8)
                            : AppColors.textFaint,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: AppText.body(
                          size: 15,
                          color: AppColors.textSecondary,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final rail = SizedBox(
      width: 28,
      child: Column(
        children: [
          const SizedBox(height: 6),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent ? AppColors.now : AppColors.backgroundDark,
              border: Border.all(color: nodeColor, width: 2),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: AppColors.now.withValues(alpha: 0.5),
                        blurRadius: 14,
                      ),
                    ]
                  : null,
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      (isCurrent ? AppColors.now : AppColors.textFaint)
                          .withValues(alpha: 0.6),
                      AppColors.textFaint.withValues(alpha: 0.18),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return FontSafeIntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isNarrow) ...[
            SizedBox(
              width: 190,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, right: 20),
                child: meta,
              ),
            ),
          ],
          rail,
          SizedBox(width: isNarrow ? 14 : 24),
          Expanded(child: content),
        ],
      ),
    );
  }
}
