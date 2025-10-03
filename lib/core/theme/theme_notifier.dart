
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _prefs;
  late bool _isDarkMode;

  bool get isDarkMode => _isDarkMode;

  ThemeNotifier() {
    _isDarkMode = false; // Valor por defecto
    _loadFromPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    _isDarkMode = _prefs?.getBool(key) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _initPrefs();
    await _prefs?.setBool(key, _isDarkMode);
    notifyListeners();
  }
}
