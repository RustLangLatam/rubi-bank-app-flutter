import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/common/language/language_preference.dart';
import 'core/utils/app_routes.dart';
import 'core/common/theme/app_theme.dart';
import 'data/providers/settings_provider.dart';

class MyApp extends ConsumerWidget {
  final ThemePreference themePreference;
  final LanguagePreference languagePreference;

  const MyApp({
    super.key,
    required this.themePreference,
    required this.languagePreference,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for theme changes
    final themeType = ref.watch(themePreferenceProvider).themeType;

    // Get the appropriate theme based on selection
    ThemeData getTheme() {
      switch (themeType) {
        case AppThemeType.systemDefault:
          final brightness = MediaQuery.of(context).platformBrightness;
          return brightness == Brightness.dark
              ? AppTheme.darkTheme
              : AppTheme.goldLightTheme;
        case AppThemeType.light:
          return AppTheme.lightTheme;
        case AppThemeType.dark:
          return AppTheme.darkTheme;
        case AppThemeType.blueDark:
          return AppTheme.blueDarkTheme;
        case AppThemeType.goldLight:
          return AppTheme.goldLightTheme;
        case AppThemeType.elegantRuby:
          return AppTheme.elegantRubyTheme;
      }
    }

    return MaterialApp(
      title: 'Rubi Bank',
      theme: getTheme(), // Directly set the theme
      // Don't use darkTheme/themeMode when using custom themes
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}