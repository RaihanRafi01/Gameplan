import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const _themeKey = 'isDarkTheme'; // Key for storing theme preference
  RxBool isDarkTheme = false.obs;

  ThemeMode get currentTheme => isDarkTheme.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadTheme(); // Load theme preference on initialization
  }

  void toggleTheme() async {
    isDarkTheme.value = !isDarkTheme.value;
    _saveTheme(isDarkTheme.value); // Save the updated theme preference
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkTheme.value = prefs.getBool(_themeKey) ?? false; // Default to light theme
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
}
