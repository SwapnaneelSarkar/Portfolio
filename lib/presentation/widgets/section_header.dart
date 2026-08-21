import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Section heading: mono eyebrow → display title → gradient underline.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final bool centered;
  final Color accentColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.centered = true,
    this.accentColor = AppColors.accentPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
        child: Column(
          crossAxisAlignment:
              centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            if (action != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: _buildTitles(textTheme)),
                  action!,
                ],
              )
            else
              _buildTitles(textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTitles(TextTheme textTheme) {
    final align =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        if (subtitle != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                centered ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              _dash(fadeLeft: true),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  subtitle!.toUpperCase(),
                  textAlign: centered ? TextAlign.center : TextAlign.start,
                  style: AppFonts.mono(
                    fontSize: 11,
                    color: accentColor,
                    letterSpacing: 2.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (centered) _dash(fadeLeft: false),
            ],
          ),
          const SizedBox(height: 14),
        ],
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _dash({required bool fadeLeft}) {
    return Container(
      width: 24,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: fadeLeft
              ? [accentColor.withValues(alpha: 0), accentColor]
              : [accentColor, accentColor.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
