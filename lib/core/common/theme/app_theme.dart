import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeOld {
  /// Dark Theme (default)
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF02040F).withOpacity(0.3), // primary-darkest
      primaryColor: const Color(0xFF0A2540), // deep-blue
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0A2540),
        secondary: Color(0xFFFCD34D),
        background: Color(0xFF02040F),
        surface: Color(0xFF1E3A5F),
        onSurface: Color(0xFF304A6E),
      ),
      primaryTextTheme: GoogleFonts.latoTextTheme(
        ThemeData.dark().primaryTextTheme,
      ),
      textTheme: GoogleFonts.latoTextTheme(base.textTheme).copyWith(
        headlineSmall: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.lato(color: Colors.white, fontSize: 20),
        bodyMedium: GoogleFonts.lato(
          color: Color(0xFFCBD5E1).withOpacity(0.8), // muted text
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
      scaffoldBackgroundColor: const Color(0xFF64748B).withOpacity(0.1), // primary-light
      primaryColor: const Color(0xFF0A2540), // accent/deep-blue
      primaryTextTheme: GoogleFonts.latoTextTheme(
        ThemeData.light().primaryTextTheme,
      ),
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
        bodyLarge: GoogleFonts.lato(color: const Color(0xFF0A2540), fontSize: 20),
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

// ThemeData that reflects the RubiBank web design system.
class RubiBankThemeOld {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF060B14),      // 'background'
      primaryColor: const Color(0xFFC5A365),                // 'primary'

      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFC5A365),                         // 'primary'
        secondary: Color(0xFFD8B77C),                       // 'primary-hover'
        background: Color(0xFF060B14),                      // 'background'
        surface: Color(0xFF0D1626),                         // 'surface-dark'
        onPrimary: Color(0xFF060B14),                       // 'on-primary'
        onSecondary: Color(0xFF060B14),
        onBackground: Color(0xFFEAEBF0),                    // 'on-background'
        onSurface: Color(0xFFFFFFFF),                       // 'on-surface'
        error: Color(0xFFEF4444),                           // Standard Red for errors
      ),

      textTheme: TextTheme(
        // For main titles (font-serif)
        headlineLarge: GoogleFonts.playfairDisplay(
          color: const Color(0xFFFFFFFF),
          fontWeight: FontWeight.bold,
        ),
        // For subtitles and body text (font-sans)
        bodyLarge: GoogleFonts.inter(color: const Color(0xFFEAEBF0)),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFF7A8C99)), // 'muted'
        // For buttons
        labelLarge: GoogleFonts.inter(
          color: const Color(0xFF060B14),
          fontWeight: FontWeight.bold,
        ),
      ).apply(
        bodyColor: const Color(0xFFEAEBF0),
        displayColor: const Color(0xFFFFFFFF),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0D1626),                 // 'surface-dark'
        contentPadding: const EdgeInsets.all(16),           // p-4
        hintStyle: const TextStyle(color: Color(0xFF7A8C99)),  // 'muted'
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFC5A365).withOpacity(0.125)),
          borderRadius: BorderRadius.circular(12.0),        // 'rounded-xl'
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: const Color(0xFFC5A365).withOpacity(0.125), // 'border-primary/20'
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFFC5A365), width: 1.5), // 'focus:border-primary'
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC5A365),          // 'primary'
          foregroundColor: const Color(0xFF060B14),          // 'on-primary'
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // py-3 px-6
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),       // 'rounded-lg'
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF060B14), // background
      primaryColor: const Color(0xFFC5A365), // primary
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFC5A365), // primary
        secondary: Color(0xFFD8B77C), // primary-hover
        background: Color(0xFF060B14), // background
        surface: Color(0xFF0D1626), // surface-dark
        onPrimary: Color(0xFF060B14), // on-primary
        onSecondary: Color(0xFF060B14),
        onBackground: Color(0xFFEAEBF0), // on-background
        onSurface: Color(0xFFFFFFFF), // on-surface
        error: Color(0xFFEF4444), // Standard Red for errors
        shadow: Color(0xFF7A8C99), // Added muted color
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 30, // text-3xl (3 * 0.25rem * 16 = 30px)
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFFFFFF), // text-on-surface
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 24, // text-2xl
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFFFFFF),
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 20, // text-xl
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFFFFFF),
        ),

        bodyLarge: GoogleFonts.inter(
          fontSize: 16, // text-base
          color: const Color(0xFFEAEBF0), // text-on-background
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, // text-sm
          color: const Color(0xFFEAEBF0), // text-on-background
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12, // text-xs
          color: const Color(0xFFEAEBF0),
        ),

        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF7A8C99), // text-muted
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF7A8C99), // text-muted
        ),

        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFEAEBF0), // text-on-background bold
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFEAEBF0),
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFEAEBF0),
        ),

        headlineSmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF060B14), // text-on-primary
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0D1626), // surface-dark
        contentPadding: const EdgeInsets.all(16), // p-4
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF7A8C99), // muted
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFC5A365).withOpacity(0.125), width: 1),
          borderRadius: BorderRadius.circular(12.0), // rounded-xl
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: const Color(0xFFC5A365).withOpacity(0.125), // border-primary/20
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFFC5A365), width: 1.5), // focus:border-primary
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC5A365), // primary
          foregroundColor: const Color(0xFF060B14), // on-primary
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // py-3 px-6
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // rounded-lg
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static LinearGradient get appGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        darkTheme.colorScheme.background, // #060B14
        darkTheme.colorScheme.surface, // #0D1626
      ],
    );
  }
}