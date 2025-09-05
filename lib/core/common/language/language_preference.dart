enum AppLanguage {
  systemDefault,
  english,
  spanish,
  french,
  german,
}

class LanguagePreference {
  final AppLanguage language;

  const LanguagePreference({required this.language});

  // Default to system language
  factory LanguagePreference.defaultValue() {
    return const LanguagePreference(language: AppLanguage.systemDefault);
  }
}