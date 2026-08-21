import 'package:flutter/material.dart';

/// Thin gradient reading-progress bar pinned under the frosted nav.
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
            height: 2.5,
            width: double.infinity,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF22D3EE),
                      Color(0xFFA78BFA),
                      Color(0xFFF471B5),
                    ],
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
