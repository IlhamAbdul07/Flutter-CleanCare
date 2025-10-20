import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  // Must call this before using the service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Example getters/setters
  static Future<void> setUserId(String userId) async {
    await _prefs.setString('user_id', userId);
  }

  static String? getUserId() {
    return _prefs.getString('user_id');
  }

  static Future<void> setUserRole(String role) async {
    await _prefs.setString('user_role', role);
  }

  static String? getUserRole() {
    return _prefs.getString('user_role');
  }

  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
