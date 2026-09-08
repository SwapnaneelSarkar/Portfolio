import 'package:flutter/material.dart';

/// Motion tokens. Every animated widget reads [reduce] and either skips its
/// loop or jumps straight to its end state when the OS asks for less motion.
class AppMotion {
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration base = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration reveal = Duration(milliseconds: 700);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuint;
  static const Curve exit = Curves.easeInCubic;

  /// True when the platform requests reduced motion.
  static bool reduce(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [d] under normal motion, zero under reduced motion.
  static Duration scaled(BuildContext context, Duration d) =>
      reduce(context) ? Duration.zero : d;
}
