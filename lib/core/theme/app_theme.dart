import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  // =========================
  // Dark Theme Colors
  // =========================

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    // Main accent color — Burgundy
    primary: Color(0xFFC47C89),
    onPrimary: Color(0xFF1D1919),

    // Secondary accent
    secondary: Color(0xFFD49BA3),
    onSecondary: Color(0xFF382D2A),

    // Antique Gold accent
    tertiary: Color(0xFFE6C58B),
    onTertiary: Color(0xFF382D2A),

    // Surfaces
    surface: Color(0xFF2B2424),
    onSurface: Color(0xFFF5EFEB),

    // Less prominent text/icons
    onSurfaceVariant: Color(0xFFB5A8A1),

    // Borders
    outline: Color(0xFF81766E),
    outlineVariant: Color(0xFF453A37),

    // Errors
    error: Color(0xFFF08C91),
    onError: Color(0xFF1D1919),

    // Containers
    primaryContainer: Color(0xFF493039),
    onPrimaryContainer: Color(0xFFF5EFEB),
    secondaryContainer: Color(0xFF453238),
    onSecondaryContainer: Color(0xFFF5EFEB),
    tertiaryContainer: Color(0xFF493A2A),
    onTertiaryContainer: Color(0xFFE6C58B),
    errorContainer: Color(0xFF482A2D),
    onErrorContainer: Color(0xFFFFDADB),

    // Shadows
    shadow: Color(0xFF000000),
  );

  // =========================
  // Light Theme Colors
  // =========================

  static const ColorScheme lightColorScheme = ColorScheme.light(
    // Main accent color — Burgundy
    primary: Color(0xFF8B3A4A),
    onPrimary: Colors.white,

    // Secondary accent
    secondary: Color(0xFFA65B62),
    onSecondary: Colors.white,

    // Antique Gold accent
    tertiary: Color(0xFFB78A45),
    onTertiary: Color(0xFF382D2A),

    // Surfaces
    surface: Colors.white,
    onSurface: Color(0xFF382D2A),

    // Less prominent text/icons
    onSurfaceVariant: Color(0xFF81766E),

    // Borders
    outline: Color(0xFFB7A99A),
    outlineVariant: Color(0xFFE9E1D6),

    // Errors
    error: Color(0xFFBE4149),
    onError: Colors.white,

    // Containers
    primaryContainer: Color(0xFFF3E3E6),
    onPrimaryContainer: Color(0xFF54232D),
    secondaryContainer: Color(0xFFF5E8E9),
    onSecondaryContainer: Color(0xFF5D3037),
    tertiaryContainer: Color(0xFFF3EBDD),
    onTertiaryContainer: Color(0xFF5B421F),
    errorContainer: Color(0xFFFBEAEC),
    onErrorContainer: Color(0xFF7A2029),

    // Shadows
    shadow: Color(0xFF707070),
  );

  // =========================
  // ThemeData
  // =========================

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    scaffoldBackgroundColor: const Color(0xFF1D1919),

    colorScheme: darkColorScheme,

    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme)
        .apply(
          bodyColor: darkColorScheme.onSurface,
          displayColor: darkColorScheme.onSurface,
        ),

    iconTheme: IconThemeData(color: darkColorScheme.onSurface),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    scaffoldBackgroundColor: const Color(0xFFF8F5EF),

    colorScheme: lightColorScheme,

    textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme)
        .apply(
          bodyColor: lightColorScheme.onSurface,
          displayColor: lightColorScheme.onSurface,
        ),

    iconTheme: IconThemeData(color: lightColorScheme.onSurface),
  );
}
