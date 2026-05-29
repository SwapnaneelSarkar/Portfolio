import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Static, low-distraction page background (no particles or motion).
class SubtlePageBackground extends StatelessWidget {
  const SubtlePageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundDark,
            Color(0xFF0E1218),
            AppColors.backgroundDark,
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}
