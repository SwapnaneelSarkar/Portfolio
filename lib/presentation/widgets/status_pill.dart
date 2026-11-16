import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

/// Board-style status label ("● SHIPPED", "● NOW"). Colour carries meaning:
/// see [AppColors.now], [AppColors.shipped], [AppColors.research].
class StatusPill extends StatefulWidget {
  final String label;
  final Color color;
  final bool pulse;

  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.pulse = false,
  });

  @override
  State<StatusPill> createState() => _StatusPillState();
}

class _StatusPillState extends State<StatusPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (widget.pulse && !reduceMotion) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;

    return Container(
      padding: const EdgeInsets.fromLTRB(9, 5, 11, 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final v = _controller.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.pulse)
                      Container(
                        width: 6 + 6 * v,
                        height: 6 + 6 * v,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.45 * (1 - v)),
                        ),
                      ),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              widget.label.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: AppText.mono(
                size: 11,
                weight: FontWeight.w600,
                color: color,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
