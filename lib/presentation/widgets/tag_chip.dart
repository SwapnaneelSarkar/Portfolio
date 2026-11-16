import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Neutral chip for skills and tech stacks. [color] only tints the border so
/// a card's status colour stays the loudest thing on it.
class TagChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool mono;

  const TagChip({
    super.key,
    required this.label,
    this.color,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
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
