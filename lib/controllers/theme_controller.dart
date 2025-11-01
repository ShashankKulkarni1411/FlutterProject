import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Observable variables
  final _themeMode = ThemeMode.dark.obs;
  final _accentColor = const Color(0xFF06B6D4).obs;

  // Getters
  ThemeMode get themeMode => _themeMode.value;
  Color get accentColor => _accentColor.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  // Load saved theme preferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode') ?? 'dark';
    final accentColorValue = prefs.getInt('accentColor') ?? 0xFF06B6D4;

    _themeMode.value = _getThemeModeFromString(themeModeString);
    _accentColor.value = Color(accentColorValue);
  }

  // Save theme preferences
  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'themeMode',
      _getStringFromThemeMode(_themeMode.value),
    );
    await prefs.setInt('accentColor', _accentColor.value.value);
  }

  // Change theme mode
  void setThemeMode(String mode) {
    switch (mode) {
      case 'light':
        _themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        _themeMode.value = ThemeMode.dark;
        break;
      case 'system':
        _themeMode.value = ThemeMode.system;
        break;
    }
    Get.changeThemeMode(_themeMode.value);
    _saveThemeToPrefs();
  }

  // Change accent color
  void setAccentColor(Color color) {
    _accentColor.value = color;
    _saveThemeToPrefs();
    // Force rebuild of app
    Get.forceAppUpdate();
  }

  // Helper methods
  ThemeMode _getThemeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  // Get current theme data
  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: accentColor,
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      colorScheme: ColorScheme.light(
        primary: accentColor,
        secondary: accentColor,
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentColor,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: const Color(0xFF1E293B),
      ),
    );
  }
}
