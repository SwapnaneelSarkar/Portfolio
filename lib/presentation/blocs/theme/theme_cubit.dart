import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Light/dark preference. Follows the OS until the visitor picks one, then
/// remembers the choice.
class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'theme_mode';

  ThemeCubit() : super(ThemeMode.system) {
    _restore();
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      switch (prefs.getString(_key)) {
        case 'light':
          emit(ThemeMode.light);
        case 'dark':
          emit(ThemeMode.dark);
      }
    } catch (_) {
      // Storage blocked (private window): stay on the OS setting.
    }
  }

  /// Flips to the opposite of whatever is currently showing.
  Future<void> toggle(Brightness showing) async {
    final next =
        showing == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, next.name);
    } catch (_) {}
  }
}
