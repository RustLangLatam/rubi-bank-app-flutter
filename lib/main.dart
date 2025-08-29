import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/providers/api_provider.dart';

// Define the base URL for the RubiBank API
const String apiBaseUrl = 'http://127.0.0.1:8000';

void main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

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
