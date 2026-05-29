import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final bool centered;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.centered = true,
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
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: textTheme.displaySmall?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.accentPrimary,
            ),
          ),
        ],
      ],
    );
  }
}
