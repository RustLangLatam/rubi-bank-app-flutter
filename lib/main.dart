import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';
import 'data/providers/api_provider.dart';

// Define the base URL for the RubiBank API
const String apiBaseUrl = 'http://192.168.1.141:8080';

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

  // Create a new provider container
  final container = ProviderContainer(
    // Initialize providers here if needed
    overrides: [],
  );

  // Initialize the API providers with the base URL
  initializeApiProviders(container, baseUrl: apiBaseUrl);

  // Run the application
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}
