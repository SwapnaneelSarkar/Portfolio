import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/core/theme/motion.dart';

/// Pulls its child a few pixels toward a nearby mouse pointer — a small
/// magnet — and eases back to rest once the pointer leaves.
///
/// Desktop-pointer only: touch input, mobile widths and reduced motion all
/// leave the child exactly where layout put it. The child is never rebuilt
/// while it moves; only a translation layer changes.
class Magnetic extends StatefulWidget {
  const Magnetic({
    super.key,
    required this.child,
    this.strength = 0.35,
    this.radius = 80,
    this.enabled = true,
  });

  final Widget child;

  /// Fraction of the pointer's offset from the child's centre that the
  /// child follows (the shift is capped at 14px regardless).
  final double strength;

  /// Distance in px outside the child's bounds within which the pull applies.
  final double radius;

  final bool enabled;

  @override
  State<Magnetic> createState() => _MagneticState();
}

class _MagneticState extends State<Magnetic>
    with SingleTickerProviderStateMixin {
  static const double _maxShift = 14;
  static const Curve _curve = Curves.easeOut;

  late final AnimationController _controller;
  Offset _from = Offset.zero;
  Offset _to = Offset.zero;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      value: 1,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncListening();
  }

  @override
  void didUpdateWidget(Magnetic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) _syncListening();
  }

  bool get _shouldListen =>
      widget.enabled &&
      !AppMotion.reduce(context) &&
      !AppLayout.isMobile(context);

  void _syncListening() {
    final want = _shouldListen;
    if (want == _listening) return;
    _listening = want;
    if (want) {
      GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
    } else {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
      _setTarget(Offset.zero);
    }
  }

  Offset get _current =>
      Offset.lerp(_from, _to, _curve.transform(_controller.value))!;

  void _setTarget(Offset target) {
    if ((target - _to).distanceSquared < 0.05) return;
    _from = _current;
    _to = target;
    _controller.forward(from: 0);
  }

  void _onPointer(PointerEvent event) {
    if (!mounted || event.kind != PointerDeviceKind.mouse) return;
    if (event is PointerRemovedEvent || event is PointerCancelEvent) {
      _setTarget(Offset.zero);
      return;
    }
    if (event is! PointerHoverEvent && event is! PointerMoveEvent) return;

    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    final p = event.position;

    // Distance from the pointer to the (rest) bounds; zero when inside.
    final dx = math.max(math.max(rect.left - p.dx, p.dx - rect.right), 0.0);
    final dy = math.max(math.max(rect.top - p.dy, p.dy - rect.bottom), 0.0);
    if (dx * dx + dy * dy > widget.radius * widget.radius) {
      _setTarget(Offset.zero);
      return;
    }

    var pull = (p - rect.center) * widget.strength;
    final length = pull.distance;
    if (length > _maxShift) pull = pull * (_maxShift / length);
    _setTarget(pull);
  }

  @override
  void dispose() {
    if (_listening) {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Same tree whether active or not, so toggling never recreates the child.
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) => Transform.translate(
          offset: _current,
          child: child,
        ),
      ),
    );
  }
}
