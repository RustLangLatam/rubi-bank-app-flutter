import '../language/language_preference.dart';
import '../theme/app_theme.dart';

abstract class SettingsRepository {
  Future<ThemePreference> getThemePreference();
  Future<void> saveThemePreference(ThemePreference preference);

  Future<LanguagePreference> getLanguagePreference();
  Future<void> saveLanguagePreference(LanguagePreference preference);

  Future<void> clearAllPreferences();
}