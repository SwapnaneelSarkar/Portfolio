import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Surface card. When [onTap] is set it becomes a focusable, hoverable link:
/// it lifts slightly and its border picks up [accentColor].
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? accentColor;
  final double borderRadius;
  final String? semanticLabel;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.accentColor,
    this.borderRadius = 20,
    this.semanticLabel,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? AppColors.marigold;
    final active = widget.onTap != null && (_hovered || _focused);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final radius = BorderRadius.circular(widget.borderRadius);

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(
        0,
        active && !reduceMotion ? -4 : 0,
        0,
      ),
      padding: widget.padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            active ? AppColors.cardHover : AppColors.cardBackground,
            AppColors.backgroundLight.withValues(alpha: 0.92),
          ],
        ),
        border: Border.all(
          color: active
              ? accent.withValues(alpha: _focused ? 0.9 : 0.5)
              : AppColors.borderSubtle,
          width: _focused ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: active
                ? accent.withValues(alpha: 0.16)
                : Colors.black.withValues(alpha: 0.18),
            blurRadius: active ? 32 : 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: widget.child,
    );

    if (widget.onTap == null) return card;

    return Semantics(
      link: true,
      label: widget.semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (v) => setState(() => _hovered = v),
          onFocusChange: (v) => setState(() => _focused = v),
          borderRadius: radius,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: accent.withValues(alpha: 0.08),
          child: card,
        ),
      ),
    );
  }
}
