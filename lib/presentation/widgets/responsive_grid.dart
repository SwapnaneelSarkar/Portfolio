import 'package:flutter/material.dart';

/// [IntrinsicHeight] that re-measures once web fonts finish loading.
///
/// Flutter 3.29's RenderParagraph refreshes its layout painter on a font
/// change but not the separate painter it uses for intrinsic sizes, so text
/// measured before Google Fonts arrive keeps fallback-font metrics and
/// overflows its row. Re-keying rebuilds the subtree with fresh measurements.
class FontSafeIntrinsicHeight extends StatefulWidget {
  final Widget child;

  const FontSafeIntrinsicHeight({super.key, required this.child});

  @override
  State<FontSafeIntrinsicHeight> createState() =>
      _FontSafeIntrinsicHeightState();
}

class _FontSafeIntrinsicHeightState extends State<FontSafeIntrinsicHeight> {
  int _fontEpoch = 0;

  @override
  void initState() {
    super.initState();
    PaintingBinding.instance.systemFonts.addListener(_onFontsChanged);
  }

  void _onFontsChanged() {
    if (mounted) setState(() => _fontEpoch++);
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts.removeListener(_onFontsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(key: ValueKey(_fontEpoch), child: widget.child);
  }
}

/// Rows of equal-height cells. Column count comes from the available width.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double minCellWidth;
  final int maxColumns;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minCellWidth = 320,
    this.maxColumns = 3,
    this.spacing = 20,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ((constraints.maxWidth + spacing) /
                (minCellWidth + spacing))
            .floor()
            .clamp(1, maxColumns);

        final rows = <Widget>[];
        for (var i = 0; i < children.length; i += columns) {
          final cells = children.sublist(
            i,
            (i + columns).clamp(0, children.length),
          );
          rows.add(
            FontSafeIntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var c = 0; c < columns; c++) ...[
                    if (c > 0) SizedBox(width: spacing),
                    Expanded(
                      child: c < cells.length ? cells[c] : const SizedBox(),
                    ),
                  ],
                ],
              ),
            ),
          );
          if (i + columns < children.length) {
            rows.add(SizedBox(height: spacing));
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }
}
