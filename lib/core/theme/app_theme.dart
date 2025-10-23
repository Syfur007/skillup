// app_theme.dart
// Defines ThemeData and theme-related helpers for the application.
// Use this to centralize light/dark themes, text styles, and component themes.

import 'package:flutter/material.dart';

/// Minimal theme implementation used by the skeleton app.
/// Expand this with design tokens and component themes as you build the UI.
class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}