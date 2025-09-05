import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/settings_provider.dart';
import '../language/language_preference.dart';
import '../theme/app_theme.dart';

class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePreference = ref.watch(themePreferenceProvider);
    final languagePreference = ref.watch(languagePreferenceProvider);
    final themeNotifier = ref.read(themePreferenceProvider.notifier);
    final languageNotifier = ref.read(languagePreferenceProvider.notifier);

    return PopupMenuButton(
      icon: Icon(
        Icons.menu,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      itemBuilder: (context) => [
        // Theme selection
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
          ),
          onTap: () => _showThemeSelectionDialog(
            context,
            themePreference.themeType,
            themeNotifier.setTheme,
          ),
        ),
        // Language selection
        PopupMenuItem(
          child: const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
          ),
          onTap: () => _showLanguageSelectionDialog(
            context,
            languagePreference.language,
            languageNotifier.setLanguage,
          ),
        ),
      ],
    );
  }

  void _showThemeSelectionDialog(
      BuildContext context,
      AppThemeType currentTheme,
      Function(AppThemeType) onThemeSelected,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppThemeType.values.length,
            itemBuilder: (context, index) {
              final theme = AppThemeType.values[index];
              return ThemeSelectionTile(
                theme: theme,
                currentTheme: currentTheme,
                onThemeSelected: onThemeSelected,
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLanguageSelectionDialog(
      BuildContext context,
      AppLanguage currentLanguage,
      Function(AppLanguage) onLanguageSelected,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppLanguage.values.length,
            itemBuilder: (context, index) {
              final language = AppLanguage.values[index];
              return RadioListTile<AppLanguage>(
                title: Text(_getLanguageName(language)),
                value: language,
                groupValue: currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    onLanguageSelected(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _getLanguageName(AppLanguage language) {
    switch (language) {
      case AppLanguage.systemDefault:
        return 'System Default';
      case AppLanguage.english:
        return 'English';
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.german:
        return 'Deutsch';
    }
  }
}

// Alternative ThemeSelectionTile with more visual preview
class ThemeSelectionTile extends StatelessWidget {
  final AppThemeType theme;
  final AppThemeType currentTheme;
  final Function(AppThemeType) onThemeSelected;

  const ThemeSelectionTile({
    super.key,
    required this.theme,
    required this.currentTheme,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: _getThemeColor(theme),
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      title: Text(_getThemeName(theme)),
      trailing: Radio<AppThemeType>(
        value: theme,
        groupValue: currentTheme,
        onChanged: (value) {
          if (value != null) {
            onThemeSelected(value);
            Navigator.of(context).pop();
          }
        },
      ),
      onTap: () {
        onThemeSelected(theme);
        Navigator.of(context).pop();
      },
    );
  }

  String _getThemeName(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.goldLight:
        return 'Gold Luxury';
      case AppThemeType.blueDark:
        return 'Blue Dark';
      case AppThemeType.elegantRuby:
        return 'Elegant Ruby';
      case AppThemeType.dark:
        return 'Dark Theme';
      case AppThemeType.light:
        return 'Light Theme';
      case AppThemeType.systemDefault:
        return 'System Default';
    }
  }

  Color _getThemeColor(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.dark:
        return const Color(0xFF121212);
      case AppThemeType.light:
        return const Color(0xFF2196F3);
      case AppThemeType.goldLight:
        return const Color(0xFFC5A365);
      case AppThemeType.blueDark:
        return const Color(0xFF1565C0);
      case AppThemeType.elegantRuby:
        return const Color(0xFF9B1C31);
      case AppThemeType.systemDefault:
        return Colors.blueGrey;
    }
  }
}