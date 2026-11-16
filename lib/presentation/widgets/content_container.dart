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
    final width = MediaQuery.sizeOf(context).width;
    final gutter = AppLayout.gutter(width);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppLayout.maxContentWidth + gutter * 2,
        ),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: gutter,
                vertical: width < 700 ? 52 : 72,
              ),
          child: child,
        ),
      ),
    );
  }
}
