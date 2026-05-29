import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class ContentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ContentContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
        child: Padding(
          padding: padding ?? AppLayout.sectionPadding,
          child: child,
        ),
      ),
    );
  }
}
