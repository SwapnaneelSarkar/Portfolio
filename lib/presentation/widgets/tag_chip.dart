import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Neutral at rest so dense chip groups read as texture, not noise.
/// The accent only appears on hover — unless [emphasized], which is
/// reserved for the few chips that carry the differentiator signal.
class TagChip extends StatefulWidget {
  final String label;
  final Color? color;
  final bool emphasized;

  const TagChip({
    super.key,
    required this.label,
    this.color,
    this.emphasized = false,
  });

  @override
  State<TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<TagChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.color ?? AppColors.accentPrimary;
    final active = _hovered || widget.emphasized;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? accent.withValues(alpha: widget.emphasized ? 0.10 : 0.08)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active
                ? accent.withValues(alpha: 0.4)
                : AppColors.borderSubtle,
          ),
        ),
        child: widget.emphasized
            ? Text(
                widget.label.toUpperCase(),
                style: AppFonts.mono(
                  fontSize: 10.5,
                  color: accent,
                  letterSpacing: 1.2,
                ),
              )
            : AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _hovered ? accent : AppColors.textBody,
                ),
                child: Text(widget.label),
              ),
      ),
    );
  }
}
