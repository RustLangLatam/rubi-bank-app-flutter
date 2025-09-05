import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeType {
  goldLight,
  blueDark,
  elegantRuby,
  dark,
  light,
  systemDefault,
}

class ThemePreference {
  final AppThemeType themeType;

  const ThemePreference({required this.themeType});

  // Default to system theme
  factory ThemePreference.defaultValue() {
    return const ThemePreference(themeType: AppThemeType.systemDefault);
  }
}

class AppTheme {
  // Dark Theme (Original RubiBank Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF060B14),
      primaryColor: const Color(0xFFC5A365),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFC5A365),
        secondary: Color(0xFFD8B77C),
        background: Color(0xFF060B14),
        surface: Color(0xFF0D1626),
        onPrimary: Color(0xFF060B14),
        onSecondary: Color(0xFF060B14),
        onBackground: Color(0xFFEAEBF0),
        onSurface: Color(0xFFFFFFFF),
        error: Color(0xFFEF4444),
        shadow: Color(0xFF7A8C99),
      ),
      textTheme: _buildTextTheme(
        bodyColor: const Color(0xFFEAEBF0),
        displayColor: const Color(0xFFFFFFFF),
        mutedColor: const Color(0xFF7A8C99),
        onPrimaryColor: const Color(0xFF060B14),
      ),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: const Color(0xFF0D1626),
        borderColor: const Color(0xFFC5A365).withOpacity(0.125),
        focusColor: const Color(0xFFC5A365),
        hintColor: const Color(0xFF7A8C99),
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: const Color(0xFFC5A365),
        foregroundColor: const Color(0xFF060B14),
      ),
    );
  }

  // Light Theme - Professional banking experience
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F9FC),
      primaryColor: const Color(0xFF2D4EC3),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2D4EC3),
        secondary: Color(0xFF4A6EE0),
        background: Color(0xFFF8F9FC),
        surface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onBackground: Color(0xFF1A2235),
        onSurface: Color(0xFF1A2235),
        error: Color(0xFFDC2626),
        shadow: Color(0xFF94A3B8),
      ),
      textTheme: _buildTextTheme(
        bodyColor: const Color(0xFF1A2235),
        displayColor: const Color(0xFF1A2235),
        mutedColor: const Color(0xFF64748B),
        onPrimaryColor: const Color(0xFFFFFFFF),
      ),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: const Color(0xFFFFFFFF),
        borderColor: const Color(0xFFE2E8F0),
        focusColor: const Color(0xFF2D4EC3),
        hintColor: const Color(0xFF94A3B8),
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: const Color(0xFF2D4EC3),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
    );
  }

  // Blue Dark Theme - Modern dark blue variant
  static ThemeData get blueDarkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A1429),
      primaryColor: const Color(0xFF4F9CF9),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4F9CF9),
        secondary: Color(0xFF78B4FF),
        background: Color(0xFF0A1429),
        surface: Color(0xFF152540),
        onPrimary: Color(0xFF0A1429),
        onSecondary: Color(0xFF0A1429),
        onBackground: Color(0xFFE2E8F8),
        onSurface: Color(0xFFFFFFFF),
        error: Color(0xFFF87171),
        shadow: Color(0xFF7C8DB0),
      ),
      textTheme: _buildTextTheme(
        bodyColor: const Color(0xFFE2E8F8),
        displayColor: const Color(0xFFFFFFFF),
        mutedColor: const Color(0xFF94A3B8),
        onPrimaryColor: const Color(0xFF0A1429),
      ),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: const Color(0xFF152540),
        borderColor: const Color(0xFF4F9CF9).withOpacity(0.2),
        focusColor: const Color(0xFF4F9CF9),
        hintColor: const Color(0xFF94A3B8),
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: const Color(0xFF4F9CF9),
        foregroundColor: const Color(0xFF0A1429),
      ),
    );
  }

  static ThemeData get goldLightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFDF6E3), // Sand beige
      primaryColor: const Color(0xFFD4AF37), // Rich gold
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD4AF37), // Premium gold
        secondary: Color(0xFFC19B2E), // Deep gold
        background: Color(0xFFFDF6E3), // Desert sand
        surface: Color(0xFFFFFFFF), // Pure white
        onPrimary: Color(0xFF2C2C2C), // Dark charcoal
        onSecondary: Color(0xFF2C2C2C),
        onBackground: Color(0xFF4A4A4A), // Dark gray
        onSurface: Color(0xFF4A4A4A),
        error: Color(0xFFC53030), // Deep red
        shadow: Color(0xFFB8A88D), // Sand shadow
      ),
      textTheme: _buildTextTheme(
        bodyColor: const Color(0xFF4A4A4A),
        displayColor: const Color(0xFF2C2C2C),
        mutedColor: const Color(0xFF8C8C8C),
        onPrimaryColor: const Color(0xFF2C2C2C),
      ),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: const Color(0xFFFFFFFF),
        borderColor: const Color(0xFFE8E2D0),
        focusColor: const Color(0xFFD4AF37),
        hintColor: const Color(0xFFB8A88D),
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: const Color(0xFF2C2C2C),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C2C2C)),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2C2C2C),
        ),
      ),
    );
  }

  // Elegant Ruby Theme - Sophisticated ruby inspiration
  static ThemeData get elegantRubyTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1A0B1C), // Deep burgundy
      primaryColor: const Color(0xFF9B1C31), // Rich ruby red
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9B1C31), // Ruby red
        secondary: Color(0xFFC42D43), // Bright ruby
        background: Color(0xFF1A0B1C), // Deep wine
        surface: Color(0xFF2D1528), // Dark plum
        onPrimary: Color(0xFFFFFFFF), // White
        onSecondary: Color(0xFFFFFFFF),
        onBackground: Color(0xFFE8D5E0), // Soft pinkish white
        onSurface: Color(0xFFE8D5E0),
        error: Color(0xFFFF6B6B), // Soft red
        shadow: Color(0xFF7A5C6B), // Muted plum
      ),
      textTheme: _buildTextTheme(
        bodyColor: const Color(0xFFE8D5E0),
        displayColor: const Color(0xFFFFFFFF),
        mutedColor: const Color(0xFFB39FAA),
        onPrimaryColor: const Color(0xFFFFFFFF),
      ),
      inputDecorationTheme: _buildInputDecorationTheme(
        fillColor: const Color(0xFF2D1528),
        borderColor: const Color(0xFF9B1C31).withOpacity(0.3),
        focusColor: const Color(0xFF9B1C31),
        hintColor: const Color(0xFFB39FAA),
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(
        backgroundColor: const Color(0xFF9B1C31),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF2D1528),
        foregroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }

  // Helper methods for consistent theme construction
  static TextTheme _buildTextTheme({
    required Color bodyColor,
    required Color displayColor,
    required Color mutedColor,
    required Color onPrimaryColor,
  }) {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: displayColor,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: displayColor,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: displayColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: bodyColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: bodyColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: bodyColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        color: mutedColor,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        color: mutedColor,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: bodyColor,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: bodyColor,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: bodyColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: onPrimaryColor,
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusColor,
    required Color hintColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.all(16),
      hintStyle: GoogleFonts.inter(
        color: hintColor,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: focusColor, width: 1.5),
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Gradient definitions for each theme
  static LinearGradient appGradient(ColorScheme colorScheme) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      colorScheme.background,
      colorScheme.surface,
    ],
  );

  static LinearGradient cardGradient(ColorScheme colorScheme) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      colorScheme.surface,
      colorScheme.background,
    ],
  );
}