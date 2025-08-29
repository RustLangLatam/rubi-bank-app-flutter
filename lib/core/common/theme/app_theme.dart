import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  /// Dark Theme (default)
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF02040F), // primary-darkest
      primaryColor: const Color(0xFF0A2540), // deep-blue
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0A2540),
        secondary: Color(0xFFFCD34D),
        background: Color(0xFF02040F),
        surface: Color(0xFF1E3A5F),
        onSurface: Color(0xFF304A6E),
      ),
      textTheme: GoogleFonts.latoTextTheme(base.textTheme).copyWith(
        headlineSmall: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.lato(color: Colors.white),
        bodyMedium: GoogleFonts.lato(
          color: const Color(0xFFA9B4C4), // muted text
        ),
        labelLarge: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A2540),
        ),
        titleMedium: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E3A5F), // input-bg
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF304A6E)), // border-dark
          borderRadius: BorderRadius.circular(10.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.5),
          borderSide: BorderSide(
            color: const Color(0xFF304A6E), // when not focused
            width: 0.8,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.5),
          borderSide: const BorderSide(
            color: Color(0xFFFCD34D), // when focused
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.5),
          borderSide: const BorderSide(
            color: Colors.red, // when error
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.5),
          borderSide: const BorderSide(
            color: Colors.red, // when focused + error
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    );
  }

  /// Light Theme
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF1F5F9), // primary-light
      primaryColor: const Color(0xFF0A2540), // accent/deep-blue
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFF1F5F9),
        secondary: Color(0xFFFCD34D),
        background: Color(0xFFF1F5F9),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFFA9B4C4),
      ),
      textTheme: GoogleFonts.latoTextTheme(base.textTheme).copyWith(
        headlineSmall: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: const Color(0xFF0A2540),
        ),
        bodyLarge: GoogleFonts.lato(color: const Color(0xFF0A2540)),
        bodyMedium: GoogleFonts.lato(
          color: const Color(0xFF64748B), // muted
        ),
        labelLarge: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0A2540),
        ),
        titleMedium: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0A2540),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(10.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.5),
          borderSide: BorderSide(
            color: const Color(0xFFE2E8F0), // when not focused
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.5),
          borderSide: const BorderSide(
            color: Color(0xFFFCD34D), // when focused
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.5),
          borderSide: const BorderSide(
            color: Colors.red, // when error
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.5),
          borderSide: const BorderSide(
            color: Colors.red, // when focused + error
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
