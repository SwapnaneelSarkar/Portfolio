import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Neutral chip for skills and tech stacks. [color] only tints the border so
/// a card's status colour stays the loudest thing on it. [emphasized] is for
/// the few chips that carry the differentiator signal (domains): tinted fill,
/// mono caps.
class TagChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool mono;
  final bool emphasized;

  const TagChip({
    super.key,
    required this.label,
    this.color,
    this.mono = false,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    if (emphasized) {
      final accent = color ?? AppColors.marigold;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: accent.withValues(alpha: 0.32)),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppText.mono(
            size: 10.5,
            weight: FontWeight.w600,
            color: accent,
            letterSpacing: 1,
          ),
        ),
      );
    }

    final border = color?.withValues(alpha: 0.22) ?? AppColors.borderSubtle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: mono
            ? AppText.mono(
                size: 11.5,
                color: AppColors.textSecondary,
                letterSpacing: 0.2,
              )
            : AppText.body(
                size: 13,
                weight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
      ),
    );
  }
}
