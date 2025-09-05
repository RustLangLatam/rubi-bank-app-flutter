import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/common/repositories/settings_repository_impl.dart';
import 'data/providers/api_provider.dart';
import 'data/providers/settings_provider.dart';

// Define the base URL for the RubiBank API
const String apiBaseUrl = 'http://192.168.1.141:8080';

const String apiKey = 'dev123';

void main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await GoogleFonts.pendingFonts([
      GoogleFonts.getFont('Lato'),
    ]).timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('Font loading failed: $e');
  }

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Override the repository provider
  final settingsRepository = SettingsRepositoryImpl(
    sharedPreferences: sharedPreferences,
  );

  // Load preferences
  final themePreference = await settingsRepository.getThemePreference();
  final languagePreference = await settingsRepository.getLanguagePreference();

  // Create a new provider container
  final container = ProviderContainer(
    // Initialize providers here if needed
    overrides: [
      settingsRepositoryProvider.overrideWithValue(settingsRepository),
    ],
  );

  // Initialize the API providers with the base URL
  initializeApiProviders(container, apiKey: apiKey, baseUrl: apiBaseUrl);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(
        themePreference: themePreference,
        languagePreference: languagePreference,
      ),
    ),
  );
}
