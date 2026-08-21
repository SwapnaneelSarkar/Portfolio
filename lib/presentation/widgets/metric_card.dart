import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/widgets/glass_card.dart';

class MetricCard extends StatelessWidget {
  final String value;
  final String label;

  /// One hero number per row gets the gradient; siblings stay solid so
  /// the set reads as designed, not accidental.
  final bool highlight;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  /// Counts every number in [value] up from 0, e.g. "$250k+" → "$141k+" → …
  String _interpolate(double t) {
    return value.replaceAllMapped(
      RegExp(r'\d+'),
      (m) => (int.parse(m[0]!) * t).round().toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valueStyle = textTheme.headlineSmall?.copyWith(
      color: highlight ? Colors.white : AppColors.textPrimary,
      fontWeight: FontWeight.w700,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      accentColor: AppColors.accentPrimary,
      tilt: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1600),
            curve: Curves.easeOutExpo,
            builder: (context, t, _) {
              final text = Text(_interpolate(t), style: valueStyle);
              if (!highlight) return text;
              return ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: AppColors.primaryGradient,
                ).createShader(bounds),
                child: text,
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(fontSize: 12, height: 1.45),
          ),
        ],
      ),
    );
  }
}
