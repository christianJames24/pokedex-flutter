import 'package:shared_preferences/shared_preferences.dart';

class DarkModeStorage {
  static const String _key = 'dark_mode';

  static Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_key, isDarkMode);
  }

  static Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }

  static Future<void> clearDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
