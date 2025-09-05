import 'package:shared_preferences/shared_preferences.dart';
import '../../common/repositories/settings_repository.dart';
import '../language/language_preference.dart';
import '../theme/app_theme.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences sharedPreferences;

  static const String _themeKey = 'theme_preference';
  static const String _languageKey = 'language_preference';

  SettingsRepositoryImpl({required this.sharedPreferences});

  @override
  Future<ThemePreference> getThemePreference() async {
    final themeIndex = sharedPreferences.getInt(_themeKey);
    if (themeIndex != null && themeIndex >= 0 && themeIndex < AppThemeType.values.length) {
      return ThemePreference(themeType: AppThemeType.values[themeIndex]);
    }
    return ThemePreference.defaultValue();
  }

  @override
  Future<void> saveThemePreference(ThemePreference preference) async {
    await sharedPreferences.setInt(_themeKey, preference.themeType.index);
  }

  @override
  Future<LanguagePreference> getLanguagePreference() async {
    final languageIndex = sharedPreferences.getInt(_languageKey);
    if (languageIndex != null && languageIndex >= 0 && languageIndex < AppLanguage.values.length) {
      return LanguagePreference(language: AppLanguage.values[languageIndex]);
    }
    return LanguagePreference.defaultValue();
  }

  @override
  Future<void> saveLanguagePreference(LanguagePreference preference) async {
    await sharedPreferences.setInt(_languageKey, preference.language.index);
  }

  @override
  Future<void> clearAllPreferences() async {
    await sharedPreferences.remove(_themeKey);
    await sharedPreferences.remove(_languageKey);
  }
}