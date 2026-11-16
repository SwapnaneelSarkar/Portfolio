import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class PressState {
  final bool hovered;
  final bool focused;
  final bool pressed;

  const PressState({
    this.hovered = false,
    this.focused = false,
    this.pressed = false,
  });
}

/// Clickable region with hover, keyboard focus and Enter/Space activation.
/// [builder] decides how each state looks, so rows, cards and nav items can
/// share one interaction model.
class Pressable extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget Function(BuildContext context, PressState state) builder;
  final String? semanticLabel;
  final bool isLink;

  const Pressable({
    super.key,
    required this.onTap,
    required this.builder,
    this.semanticLabel,
    this.isLink = false,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  void _set(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return FocusableActionDetector(
      enabled: enabled,
      mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onShowHoverHighlight: (v) => _set(() => _hovered = v),
      onShowFocusHighlight: (v) => _set(() => _focused = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: Semantics(
        button: !widget.isLink,
        link: widget.isLink,
        label: widget.semanticLabel,
        enabled: enabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onTapDown: enabled ? (_) => _set(() => _pressed = true) : null,
          onTapUp: enabled ? (_) => _set(() => _pressed = false) : null,
          onTapCancel: enabled ? () => _set(() => _pressed = false) : null,
          child: widget.builder(
            context,
            PressState(hovered: _hovered, focused: _focused, pressed: _pressed),
          ),
        ),
      ),
    );
  }
}

/// Keyboard focus outline, drawn outside the element.
BoxBorder? focusOutline(BuildContext context, bool focused) => focused
    ? Border.all(color: context.palette.accent, width: 2)
    : null;

enum StatusKind { shipped, progress, todo }

/// Issue-tracker status glyphs: dashed ring (not started), half-filled ring
/// (in progress), filled check (done).
class StatusIcon extends StatelessWidget {
  final StatusKind kind;
  final double size;

  const StatusIcon(this.kind, {super.key, this.size = 14});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = switch (kind) {
      StatusKind.shipped => p.shipped,
      StatusKind.progress => p.progress,
      StatusKind.todo => p.textFaint,
    };
    return CustomPaint(
      size: Size.square(size),
      painter: _StatusPainter(kind, color, p.surface),
    );
  }
}

class _StatusPainter extends CustomPainter {
  final StatusKind kind;
  final Color color;
  final Color knockout;

  _StatusPainter(this.kind, this.color, this.knockout);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 0.75;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final fill = Paint()..color = color;

    switch (kind) {
      case StatusKind.shipped:
        canvas.drawCircle(c, r + 0.75, fill);
        final s = size.width;
        final check = Path()
          ..moveTo(s * 0.29, s * 0.52)
          ..lineTo(s * 0.44, s * 0.66)
          ..lineTo(s * 0.72, s * 0.37);
        canvas.drawPath(
          check,
          Paint()
            ..color = knockout
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.12
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      case StatusKind.progress:
        canvas.drawCircle(c, r, stroke);
        canvas.drawArc(
          Rect.fromCircle(center: c, radius: r - 2.5),
          -math.pi / 2,
          math.pi,
          true,
          fill,
        );
      case StatusKind.todo:
        const dashes = 8;
        for (var i = 0; i < dashes; i++) {
          final start = (i / dashes) * 2 * math.pi;
          canvas.drawArc(
            Rect.fromCircle(center: c, radius: r),
            start,
            (2 * math.pi / dashes) * 0.55,
            false,
            stroke,
          );
        }
    }
  }

  @override
  bool shouldRepaint(_StatusPainter old) =>
      old.kind != kind || old.color != color || old.knockout != knockout;
}

/// Small rounded label, optionally with a colour dot.
class LabelChip extends StatelessWidget {
  final String label;
  final Color? dot;

  const LabelChip(this.label, {super.key, this.dot});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot != null) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppText.ui(
              size: 12,
              weight: FontWeight.w500,
              color: p.textMuted,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tinted status badge, e.g. "Shipped", "On track", "Now".
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Widget? leading;

  const StatusBadge(this.label, {super.key, required this.color, this.leading});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: p.tint(color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 6)],
          Text(
            label,
            style: AppText.ui(
              size: 12,
              weight: FontWeight.w600,
              color: color,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// A pulsing-free green dot: availability, not decoration.
class Dot extends StatelessWidget {
  final Color color;
  final double size;

  const Dot(this.color, {super.key, this.size = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.35), spreadRadius: 2.5),
        ],
      ),
    );
  }
}

/// Bordered container. With [onTap] it becomes a card with hover and focus.
class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final Color? color;

  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.semanticLabel,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    if (onTap == null) {
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? p.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: p.border),
        ),
        child: child,
      );
    }
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      builder: (context, s) => AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: padding,
        decoration: BoxDecoration(
          color: s.hovered ? p.sunken : (color ?? p.surface),
          borderRadius: BorderRadius.circular(10),
          border: s.focused
              ? Border.all(color: p.accent, width: 2)
              : Border.all(color: s.hovered ? p.borderStrong : p.border),
        ),
        child: child,
      ),
    );
  }
}

/// Section heading in tool style: title, optional count, optional action.
class SectionTitle extends StatelessWidget {
  final String title;
  final String? count;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionTitle(
    this.title, {
    super.key,
    this.count,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text.rich(
                    TextSpan(
                      text: title,
                      children: [
                        if (count != null)
                          TextSpan(
                            text: '  $count',
                            style: AppText.mono(
                              size: 12,
                              color: p.textFaint,
                            ),
                          ),
                      ],
                    ),
                    style: AppText.ui(
                      size: 16,
                      weight: FontWeight.w600,
                      color: p.text,
                    ),
                  ),
                ),
              ),
              if (actionLabel != null)
                TextButton(
                  onPressed: onAction,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(actionLabel!),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 14),
                    ],
                  ),
                ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description!,
              style: AppText.ui(size: 14, color: p.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

/// Keyboard key hint, e.g. ⌘K.
class Kbd extends StatelessWidget {
  final String keys;

  const Kbd(this.keys, {super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: p.border),
      ),
      child: Text(
        keys,
        style: AppText.mono(size: 11, color: p.textFaint, height: 1.4),
      ),
    );
  }
}

/// Head-and-shoulders photo on a warm tile, like a workspace icon.
class Avatar extends StatelessWidget {
  final double size;
  final double radius;

  const Avatar({super.key, this.size = 28, this.radius = 7});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB27F), Color(0xFFE4531B)],
        ),
      ),
      child: Image.asset(
        Assets.avatarCutout,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        semanticLabel: 'Swapnaneel Sarkar',
      ),
    );
  }
}

/// Label/value line used in property panels.
class PropertyRow extends StatelessWidget {
  final String label;
  final Widget child;
  final double labelWidth;

  const PropertyRow({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth = 92,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                label,
                style: AppText.ui(size: 13, color: p.textFaint),
              ),
            ),
          ),
          Expanded(
            child: DefaultTextStyle(
              style: AppText.ui(size: 13.5, color: p.text, height: 1.4),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Text link with an underline on hover.
class InlineLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final double size;
  final Color? color;

  const InlineLink(
    this.label, {
    super.key,
    required this.onTap,
    this.icon,
    this.size = 13.5,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Pressable(
      onTap: onTap,
      isLink: true,
      builder: (context, s) {
        final c = s.hovered || s.focused ? p.text : (color ?? p.textMuted);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: focusOutline(context, s.focused),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size + 1, color: c),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.ui(
                    size: size,
                    weight: FontWeight.w500,
                    color: c,
                  ).copyWith(
                    decoration: s.hovered
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: c,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
