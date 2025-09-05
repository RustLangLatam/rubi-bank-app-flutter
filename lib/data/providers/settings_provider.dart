import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/language/language_preference.dart';
import '../../core/common/repositories/settings_repository.dart';
import '../../core/common/theme/app_theme.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError('SettingsRepository should be overridden');
});

final themePreferenceProvider = StateNotifierProvider<ThemePreferenceNotifier, ThemePreference>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return ThemePreferenceNotifier(repository);
});

final languagePreferenceProvider = StateNotifierProvider<LanguagePreferenceNotifier, LanguagePreference>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return LanguagePreferenceNotifier(repository);
});

class ThemePreferenceNotifier extends StateNotifier<ThemePreference> {
  final SettingsRepository _repository;

  ThemePreferenceNotifier(this._repository) : super(ThemePreference.defaultValue()) {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final preference = await _repository.getThemePreference();
    state = preference;
  }

  Future<void> setTheme(AppThemeType themeType) async {
    final newPreference = ThemePreference(themeType: themeType);
    await _repository.saveThemePreference(newPreference);
    state = newPreference;
  }
}

class LanguagePreferenceNotifier extends StateNotifier<LanguagePreference> {
  final SettingsRepository _repository;

  LanguagePreferenceNotifier(this._repository) : super(LanguagePreference.defaultValue()) {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final preference = await _repository.getLanguagePreference();
    state = preference;
  }

  Future<void> setLanguage(AppLanguage language) async {
    final newPreference = LanguagePreference(language: language);
    await _repository.saveLanguagePreference(newPreference);
    state = newPreference;
  }
}