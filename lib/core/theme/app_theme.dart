// app_theme.dart
// Defines ThemeData and theme-related helpers for the application.
// Use this to centralize light/dark themes, text styles, and component themes.

import 'package:flutter/material.dart';

/// Comprehensive theme implementation with modern and slick color palette.
/// Features carefully crafted light and dark themes with consistent design tokens.
class AppTheme {
  AppTheme._();

  // Modern Color Palette
  // Light Mode Colors
  static const Color _lightPrimary = Color(0xFF6366F1); // Indigo
  static const Color _lightSecondary = Color(0xFF8B5CF6); // Purple
  static const Color _lightTertiary = Color(0xFF06B6D4); // Cyan
  static const Color _lightSuccess = Color(0xFF10B981); // Green
  static const Color _lightWarning = Color(0xFFF59E0B); // Amber
  static const Color _lightError = Color(0xFFEF4444); // Red
  static const Color _lightSurface = Color(0xFFFFFFFF); // White
  static const Color _lightSurfaceVariant = Color(0xFFF1F5F9); // Cool gray 100

  // Dark Mode Colors
  static const Color _darkPrimary = Color(0xFF818CF8); // Lighter indigo
  static const Color _darkSecondary = Color(0xFFA78BFA); // Lighter purple
  static const Color _darkTertiary = Color(0xFF22D3EE); // Lighter cyan
  static const Color _darkSuccess = Color(0xFF34D399); // Lighter green
  static const Color _darkWarning = Color(0xFFFBBF24); // Lighter amber
  static const Color _darkError = Color(0xFFF87171); // Lighter red
  static const Color _darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color _darkSurfaceVariant = Color(0xFF334155); // Slate 700

  // Text Colors
  static const Color _lightOnSurface = Color(0xFF1E293B); // Slate 800
  static const Color _darkOnSurface = Color(0xFFF1F5F9); // Cool gray 100

  /// Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.light(
      primary: _lightPrimary,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFEEF2FF), // Indigo 50
      onPrimaryContainer: const Color(0xFF312E81), // Indigo 900

      secondary: _lightSecondary,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFF5F3FF), // Purple 50
      onSecondaryContainer: const Color(0xFF4C1D95), // Purple 900

      tertiary: _lightTertiary,
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFECFEFF), // Cyan 50
      onTertiaryContainer: const Color(0xFF164E63), // Cyan 900

      error: _lightError,
      onError: Colors.white,
      errorContainer: const Color(0xFFFEE2E2), // Red 50
      onErrorContainer: const Color(0xFF7F1D1D), // Red 900

      surface: _lightSurface,
      onSurface: _lightOnSurface,
      surfaceContainerHighest: _lightSurfaceVariant,
      onSurfaceVariant: const Color(0xFF475569), // Slate 600

      outline: const Color(0xFFCBD5E1), // Slate 300
      outlineVariant: const Color(0xFFE2E8F0), // Slate 200

      inverseSurface: const Color(0xFF1E293B), // Slate 800
      onInverseSurface: const Color(0xFFF8FAFC), // Cool gray 50
      inversePrimary: _darkPrimary,
    ),

    scaffoldBackgroundColor: const Color(0xFFF8FAFC),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      backgroundColor: _lightSurface,
      foregroundColor: _lightOnSurface,
      surfaceTintColor: _lightPrimary,
      titleTextStyle: TextStyle(
        color: _lightOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: _lightSurface,
      surfaceTintColor: _lightPrimary,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: _lightPrimary, width: 1.5),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _lightError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _lightSurfaceVariant,
      selectedColor: _lightPrimary,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      selectedItemColor: _lightPrimary,
      unselectedItemColor: Color(0xFF94A3B8), // Slate 400
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );

  /// Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
      primary: _darkPrimary,
      onPrimary: const Color(0xFF1E1B4B), // Indigo 950
      primaryContainer: const Color(0xFF4338CA), // Indigo 700
      onPrimaryContainer: const Color(0xFFE0E7FF), // Indigo 100

      secondary: _darkSecondary,
      onSecondary: const Color(0xFF2E1065), // Purple 950
      secondaryContainer: const Color(0xFF6D28D9), // Purple 700
      onSecondaryContainer: const Color(0xFFEDE9FE), // Purple 100

      tertiary: _darkTertiary,
      onTertiary: const Color(0xFF083344), // Cyan 950
      tertiaryContainer: const Color(0xFF0E7490), // Cyan 700
      onTertiaryContainer: const Color(0xFFCFFAFE), // Cyan 100

      error: _darkError,
      onError: const Color(0xFF450A0A), // Red 950
      errorContainer: const Color(0xFFB91C1C), // Red 700
      onErrorContainer: const Color(0xFFFEE2E2), // Red 100

      surface: _darkSurface,
      onSurface: _darkOnSurface,
      surfaceContainerHighest: _darkSurfaceVariant,
      onSurfaceVariant: const Color(0xFFCBD5E1), // Slate 300

      outline: const Color(0xFF475569), // Slate 600
      outlineVariant: const Color(0xFF334155), // Slate 700

      inverseSurface: const Color(0xFFF1F5F9), // Cool gray 100
      onInverseSurface: const Color(0xFF0F172A), // Slate 900
      inversePrimary: _lightPrimary,
    ),

    scaffoldBackgroundColor: const Color(0xFF0F172A),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      backgroundColor: _darkSurface,
      foregroundColor: _darkOnSurface,
      surfaceTintColor: _darkPrimary,
      titleTextStyle: TextStyle(
        color: _darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: _darkSurface,
      surfaceTintColor: _darkPrimary,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: _darkPrimary, width: 1.5),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF475569)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF475569)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _darkSurfaceVariant,
      selectedColor: _darkPrimary,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      backgroundColor: _darkSurface,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      selectedItemColor: _darkPrimary,
      unselectedItemColor: Color(0xFF64748B), // Slate 500
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: _darkSurface,
    ),
  );

  // Utility colors accessible to widgets
  static const Color successLight = _lightSuccess;
  static const Color successDark = _darkSuccess;
  static const Color warningLight = _lightWarning;
  static const Color warningDark = _darkWarning;
}

