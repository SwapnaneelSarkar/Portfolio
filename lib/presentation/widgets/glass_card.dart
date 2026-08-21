import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Frosted panel with a top accent hairline; lifts and glows on hover.
/// With [tilt], the card also tracks the pointer with a subtle 3D tilt.
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? accentColor;
  final double borderRadius;
  final bool hoverLift;
  final bool tilt;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.accentColor,
    this.borderRadius = 16,
    this.hoverLift = true,
    this.tilt = false,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  /// Pointer position relative to card center, each axis in [-1, 1].
  Offset _pointer = Offset.zero;

  static const _maxTiltRad = 0.018;

  void _onHover(PointerEvent event) {
    if (!widget.tilt) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final local = box.globalToLocal(event.position);
    setState(() {
      _pointer = Offset(
        (local.dx / box.size.width * 2 - 1).clamp(-1, 1),
        (local.dy / box.size.height * 2 - 1).clamp(-1, 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? AppColors.accentPrimary;
    final lifted = _hovered && widget.hoverLift;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, lifted ? -4 : 0, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: lifted ? 0.07 : 0.05),
            Colors.white.withValues(alpha: 0.015),
          ],
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        // Neutral border at rest — the accent lives in the top hairline
        // and only reaches the border on hover.
        border: Border.all(
          color: lifted
              ? accent.withValues(alpha: 0.5)
              : AppColors.borderSubtle,
        ),
        boxShadow: lifted
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.14),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          children: [
            // Top accent hairline.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: widget.accentColor != null || lifted ? 1 : 0,
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: 0),
                        accent.withValues(alpha: 0.55),
                        accent.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: widget.padding ?? const EdgeInsets.all(24),
              child: widget.child,
            ),
          ],
        ),
      ),
    );

    final tiltEnabled =
        widget.tilt && MediaQuery.sizeOf(context).width >= 900;

    Widget interactive = card;
    if (tiltEnabled) {
      interactive = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0009)
          ..rotateX(_hovered ? -_pointer.dy * _maxTiltRad : 0)
          ..rotateY(_hovered ? _pointer.dx * _maxTiltRad : 0),
        child: card,
      );
    }
    interactive = RepaintBoundary(child: interactive);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pointer = Offset.zero;
      }),
      onHover: _onHover,
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: widget.onTap == null
          ? interactive
          : GestureDetector(onTap: widget.onTap, child: interactive),
    );
  }
}
