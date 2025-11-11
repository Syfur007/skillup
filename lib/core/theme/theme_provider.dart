// theme_provider.dart
// Manages theme state (light/dark mode) for the application.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for theme mode state management
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

/// Notifier to manage theme mode with persistence
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _themeModeKey = 'theme_mode';

  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  /// Load saved theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeModeKey);

      if (themeModeString != null) {
        state = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (e) {
      // If loading fails, keep default system theme
      debugPrint('Failed to load theme mode: $e');
    }
  }

  /// Save theme mode to shared preferences
  Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.toString());
    } catch (e) {
      debugPrint('Failed to save theme mode: $e');
    }
  }

  /// Set theme mode to light
  void setLightMode() {
    state = ThemeMode.light;
    _saveThemeMode(ThemeMode.light);
  }

  /// Set theme mode to dark
  void setDarkMode() {
    state = ThemeMode.dark;
    _saveThemeMode(ThemeMode.dark);
  }

  /// Set theme mode to system
  void setSystemMode() {
    state = ThemeMode.system;
    _saveThemeMode(ThemeMode.system);
  }

  /// Toggle between light and dark mode (ignoring system)
  void toggleTheme() {
    if (state == ThemeMode.light) {
      setDarkMode();
    } else {
      setLightMode();
    }
  }

  /// Check if current theme is dark
  bool isDarkMode(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}

