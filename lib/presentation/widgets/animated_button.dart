import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isPrimary;
  final IconData? trailingIcon;

  const AnimatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isPrimary = true,
    this.trailingIcon,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.inter(
      fontSize: 15,
      fontWeight: widget.isPrimary ? FontWeight.w700 : FontWeight.w600,
      letterSpacing: 0.3,
      color: widget.isPrimary
          ? const Color(0xFF041018)
          : (_isHovered ? AppColors.accentPrimary : AppColors.textPrimary),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
            decoration: BoxDecoration(
              gradient: widget.isPrimary
                  ? const LinearGradient(colors: AppColors.primaryGradient)
                  : null,
              color: widget.isPrimary
                  ? null
                  : (_isHovered
                      ? AppColors.accentPrimary.withValues(alpha: 0.08)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(12),
              border: widget.isPrimary
                  ? null
                  : Border.all(
                      color: _isHovered
                          ? AppColors.accentPrimary
                          : Colors.white.withValues(alpha: 0.22),
                      width: 1.2,
                    ),
              boxShadow: widget.isPrimary && _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.accentPrimary.withValues(alpha: 0.35),
                        blurRadius: 26,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.text, style: textStyle),
                if (widget.trailingIcon != null)
                  AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.only(left: _isHovered ? 10 : 6),
                    child: Icon(
                      widget.trailingIcon,
                      size: 16,
                      color: widget.isPrimary
                          ? const Color(0xFF041018)
                          : (_isHovered
                              ? AppColors.accentPrimary
                              : AppColors.textPrimary),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
