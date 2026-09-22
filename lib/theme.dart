import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFFFFBA08);
  static const Color primaryVariant = Color(0xFFFAA307);
  static const Color secondary = Color(0xFFF48C06);
  static const Color secondaryVariant = Color(0xFFE85D04);
  static const Color background = Color(0xFF03071E);
  static const Color error = Color(0xFFB00020);
}


final appTheme = ThemeData(
  
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2),  // ✅ Quand actif
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2),  // ✅ Quand actif
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),

  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
    ),
  ),
);