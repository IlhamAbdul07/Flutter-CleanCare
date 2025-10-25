import 'dart:convert';

import 'package:flutter_cleancare/data/models/user_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  // Must call this before using the service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Example getters/setters
  static Future<void> setToken(String token) async {
    await _prefs.setString('token', token);
  }

  static String? getToken() {
    return _prefs.getString('token');
  }

  static Future<void> setUser(Map<String, dynamic> userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userJson));
  }

  static Future<User?> getUser() async {
    final userString = _prefs.getString('user_data');
    if (userString != null) {
      final userJson = jsonDecode(userString);
      return User(
        id: userJson['id'] ?? '',
        numberId: userJson['number_id'] ?? '',
        name: userJson['name'] ?? '',
        email: userJson['email'] ?? '',
        createdAt: userJson['created_at'] ?? '',
        profile: userJson['profile'] ?? '',
        profileName: userJson['profile_name'] ?? '',
        roleId: userJson['role_id'] ?? '',
        roleName: userJson['role_name'] ?? '',
      );
    }
    return null;
  }

  static final _box = GetStorage();
  static const _themeKey = 'isDarkMode';

  static bool loadTheme() {
    return _box.read(_themeKey) ?? false;
  }

  static void saveTheme(bool isDarkMode) {
    _box.write(_themeKey, isDarkMode);
  }
}
