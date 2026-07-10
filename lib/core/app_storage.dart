import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static const String _loginKey = 'isLoggedIn';
  static const String _themeKey = 'isDarkMode';
  static const String _savedCitiesKey = 'saved_cities';

  static Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _loginKey,
      true,
    );
  }

  static Future<List<String>> getSavedCities() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getStringList(_savedCitiesKey) ?? [];
}

  static Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();

    final cities =
        prefs.getStringList(_savedCitiesKey) ?? [];

    final cleanCity = city.trim();

    if (cleanCity.isEmpty) {
    return;
    }

    final alreadyExists = cities.any(
      (savedCity) =>
          savedCity.toLowerCase() ==
          cleanCity.toLowerCase(),
    );

    if (!alreadyExists) {
      cities.add(cleanCity);

      await prefs.setStringList(
        _savedCitiesKey,
        cities,
      );
    }
  }

  static Future<void> removeSavedCity(
    String city,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final cities =
        prefs.getStringList(_savedCitiesKey) ?? [];

    cities.removeWhere(
      (savedCity) =>
          savedCity.toLowerCase() ==
          city.toLowerCase(),
    );

    await prefs.setStringList(
      _savedCitiesKey,
      cities,
    );
  }

  static Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
  }
  
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_loginKey) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_loginKey);
  }

  static Future<void> saveTheme(
    bool isDarkMode,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _themeKey,
      isDarkMode,
    );
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_themeKey) ?? false;
  }
}