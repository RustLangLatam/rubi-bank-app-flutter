import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _userRegisteredKey = 'user_registered';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  final SharedPreferences _preferences;

  UserPreferencesService(this._preferences);

  // Check if user is registered
  Future<bool> isUserRegistered() async {
    return _preferences.getBool(_userRegisteredKey) ?? false;
  }

  // Save user registration status
  Future<void> setUserRegistered(bool registered) async {
    await _preferences.setBool(_userRegisteredKey, registered);
  }

  // Save user name
  Future<void> saveUserName(String name) async {
    await _preferences.setString(_userNameKey, name);
  }

  // Get user name
  Future<String?> getUserName() async {
    return _preferences.getString(_userNameKey);
  }

  // Save user email
  Future<void> saveUserEmail(String email) async {
    await _preferences.setString(_userEmailKey, email);
  }

  // Get user email
  Future<String?> getUserEmail() async {
    return _preferences.getString(_userEmailKey);
  }

  // Clear all user data (logout)
  Future<void> clearUserData() async {
    await _preferences.remove(_userRegisteredKey);
    await _preferences.remove(_userNameKey);
    await _preferences.remove(_userEmailKey);
  }
}