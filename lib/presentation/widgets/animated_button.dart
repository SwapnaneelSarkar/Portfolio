import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Pill button. Primary is marigold (the "act now" colour); secondary is a
/// quiet outline. An optional trailing [icon] nudges right on hover.
class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isPrimary;
  final IconData? icon;
  final bool compact;

  const AnimatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isPrimary = true,
    this.icon,
    this.compact = false,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    final primary = widget.isPrimary;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final fg = primary ? AppColors.backgroundDark : AppColors.textPrimary;

    final padding = widget.compact
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          onHover: (v) => setState(() => _hovered = v),
          onFocusChange: (v) => setState(() => _focused = v),
          customBorder: const StadiumBorder(),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: (primary ? Colors.black : AppColors.marigold)
              .withValues(alpha: 0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: padding,
            transform: Matrix4.translationValues(
              0,
              active && !reduceMotion ? -2 : 0,
              0,
            ),
            decoration: BoxDecoration(
              color: primary
                  ? (active ? const Color(0xFFFFC266) : AppColors.marigold)
                  : (active
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: primary
                    ? (_focused ? AppColors.textPrimary : AppColors.marigold)
                    : (active ? AppColors.marigold : AppColors.borderStrong),
                width: _focused ? 2 : 1,
              ),
              boxShadow: primary && active
                  ? [
                      BoxShadow(
                        color: AppColors.marigold.withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.text,
                  style: AppText.body(
                    size: widget.compact ? 14 : 15,
                    weight: FontWeight.w600,
                    color: fg,
                    height: 1,
                  ),
                ),
                if (widget.icon != null) ...[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: active && !reduceMotion ? 12 : 8,
                    height: 0,
                  ),
                  Icon(widget.icon, size: 17, color: fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
