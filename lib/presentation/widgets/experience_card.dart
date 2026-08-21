import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';
import 'package:portfolio/presentation/widgets/tag_chip.dart';

/// Professional experience block — readable on mobile and desktop.
class ExperienceCard extends StatelessWidget {
  final ExperienceEntry experience;

  const ExperienceCard({
    super.key,
    required this.experience,
  });

  /// "Dim prose, bright numbers": figures and money get full weight so a
  /// recruiter can skim the outcomes in seconds.
  static final _figurePattern = RegExp(
    r'([\$₹][\d,]+[kKLM]?\+?|\d+[\d,]*(?:–\d+[\d,]*)?\s?(?:lakhs?/year|lakhs?|L/year|L\b|%|\+)|\b\d+\+|\b0 to 1\b)',
  );

  TextSpan _scanSpan(String text, TextStyle base) {
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final m in _figurePattern.allMatches(text)) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, m.start)));
      }
      spans.add(
        TextSpan(
          text: m[0],
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      cursor = m.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return TextSpan(style: base, children: spans);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isNarrow = MediaQuery.sizeOf(context).width < 600;

    return GlassCard(
      accentColor: experience.color,
      padding: EdgeInsets.all(isNarrow ? 20 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNarrow)
            _buildHeaderColumn(textTheme)
          else
            _buildHeaderRow(textTheme),
          if (experience.domains.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              'DOMAINS',
              style: AppFonts.mono(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final d in experience.domains)
                  TagChip(
                    label: d,
                    color: experience.color,
                    emphasized: true,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppLayout.maxProseWidth),
            child: Text(
              experience.description,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textBody,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'KEY OUTCOMES',
            style: AppFonts.mono(
              fontSize: 10.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppLayout.maxProseWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in experience.responsibilities)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 9),
                          child: Container(
                            width: 12,
                            height: 2,
                            decoration: BoxDecoration(
                              color:
                                  experience.color.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text.rich(
                            _scanSpan(
                              item,
                              textTheme.bodyMedium!.copyWith(
                                color: AppColors.textBody,
                                height: 1.55,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(experience.company, style: textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                experience.position,
                style: textTheme.titleMedium?.copyWith(
                  color: experience.color,
                ),
              ),
              if (experience.location.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(experience.location, style: textTheme.bodySmall),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        _PeriodBadge(period: experience.period),
      ],
    );
  }

  Widget _buildHeaderColumn(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(experience.company, style: textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          experience.position,
          style: textTheme.titleMedium?.copyWith(color: experience.color),
        ),
        if (experience.location.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(experience.location, style: textTheme.bodySmall),
        ],
        const SizedBox(height: 10),
        _PeriodBadge(period: experience.period),
      ],
    );
  }
}

class _PeriodBadge extends StatelessWidget {
  final String period;

  const _PeriodBadge({required this.period});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Text(
        period,
        style: AppFonts.mono(fontSize: 11, letterSpacing: 0.5),
      ),
    );
  }
}
