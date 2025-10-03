import 'package:flutter/material.dart';

class AppColors {
  static AppColorPalette dark() {
    return AppColorPalette(
      primary: const Color(0xFF7B1FA2),
      secondary: const Color.fromARGB(255, 44, 59, 108),
      background: const Color.fromARGB(255, 26, 92, 192),
      surface: Colors.white,
      error: Colors.redAccent,
      textDark: const Color(0xFF333333),
      textGrey: const Color(0xFF757575),
      primaryDark: const Color.fromARGB(255, 20, 1, 1),
      secondaryDark: Colors.grey.shade800, // Added
      textLight: Colors.white, // Added
    );
  }

  static AppColorPalette light() {
    return AppColorPalette(
      primary: const Color(0xFF7B1FA2),
      secondary: const Color.fromARGB(255, 44, 59, 108),
      background: Colors.white,
      surface: Colors.grey.shade100,
      error: Colors.redAccent,
      textDark: const Color(0xFF333333),
      textGrey: const Color(0xFF757575),
      primaryDark: const Color.fromARGB(255, 20, 1, 1),
      secondaryDark: Colors.grey.shade300,
      textLight: Colors.black,
    );
  }
}

class AppColorPalette {
  const AppColorPalette({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    required this.textDark,
    required this.textGrey,
    required this.primaryDark,
    required this.secondaryDark, // Added
    required this.textLight, // Added
  });

  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;
  final Color textDark;
  final Color textGrey;
  final Color primaryDark;
  final Color secondaryDark; // Added
  final Color textLight; // Added
}