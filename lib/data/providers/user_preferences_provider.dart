import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/services/user_preferences_service.dart';

final userPreferencesServiceProvider = Provider<UserPreferencesService>((ref) {
  throw UnimplementedError('UserPreferencesService should be overridden');
});

final userRegisteredProvider = FutureProvider<bool>((ref) async {
  final userService = ref.watch(userPreferencesServiceProvider);
  return await userService.isUserRegistered();
});

final userNameProvider = FutureProvider<String?>((ref) async {
  final userService = ref.watch(userPreferencesServiceProvider);
  return await userService.getUserName();
});