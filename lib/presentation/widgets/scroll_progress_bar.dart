import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Thin marigold reading-progress bar along the top edge of the viewport.
class ScrollProgressBar extends StatelessWidget {
  final ScrollController controller;

  const ScrollProgressBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          double fraction = 0;
          if (controller.hasClients &&
              controller.position.hasContentDimensions &&
              controller.position.maxScrollExtent > 0) {
            fraction = (controller.offset /
                    controller.position.maxScrollExtent)
                .clamp(0.0, 1.0);
          }
          return SizedBox(
            height: 3,
            width: double.infinity,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.primaryGradient),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(3),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
