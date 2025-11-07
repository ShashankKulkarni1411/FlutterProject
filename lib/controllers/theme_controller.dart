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
    // Don't load here, will be loaded in main
  }

  // Load initial settings - called from main before app starts
  Future<void> loadInitialSettings() async {
    await _loadThemeFromPrefs();
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
        'themeMode', _getStringFromThemeMode(_themeMode.value));
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
    // Obx in main.dart will automatically rebuild when accentColor changes
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
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      colorScheme: ColorScheme.light(
        primary: accentColor,
        secondary: accentColor,
        surface: Colors.white,
        onSurface: Colors.black87,
        surfaceVariant: Colors.grey[100]!,
        onSurfaceVariant: Colors.grey[700]!,
        background: const Color(0xFFF8FAFC),
        onBackground: Colors.black87,
      ),
      cardTheme: CardThemeData(
        color: Colors.white, // Will be overridden by colorScheme.surface in widgets
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.black54),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentColor,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: const Color(0xFF1E293B),
        onSurface: Colors.white,
        surfaceVariant: const Color(0xFF334155),
        onSurfaceVariant: Colors.grey[400]!,
        background: const Color(0xFF0F172A),
        onBackground: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B), // Will be overridden by colorScheme.surface in widgets
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white70),
      ),
    );
  }
}
