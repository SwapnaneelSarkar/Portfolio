import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Reveal-on-scroll entrance: content fades/slides in the first time it
/// becomes visible in the viewport (plus an optional stagger [delay]).
class FadeInSection extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset slideOffset;

  const FadeInSection({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 700),
    this.slideOffset = const Offset(0, 24),
  });

  @override
  State<FadeInSection> createState() => _FadeInSectionState();
}

class _FadeInSectionState extends State<FadeInSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  final Key _visibilityKey = UniqueKey();
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  void _onVisibility(VisibilityInfo info) {
    if (_revealed || info.visibleFraction < 0.05) return;
    _revealed = true;
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _onVisibility,
      child: FadeTransition(
        opacity: _fade,
        // Pixel-based rise (SlideTransition offsets are fractions of the
        // child's size — a 24px intent would become 24x the height).
        child: AnimatedBuilder(
          animation: _fade,
          builder: (context, child) => Transform.translate(
            offset: widget.slideOffset * (1 - _fade.value),
            child: child,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
