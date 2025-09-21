import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData mainTheme = ThemeData(
    primaryColor: const Color(0xFF48A9A6),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFFE47978),
      onSurface: const Color(0xFF2C3E50), // For body text
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F9F9),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodyLarge: GoogleFonts.lato(),
      bodyMedium: GoogleFonts.lato(color: const Color(0xFF2C3E50)),
      bodySmall: GoogleFonts.lato(),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF48A9A6),
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF48A9A6),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
  );
}