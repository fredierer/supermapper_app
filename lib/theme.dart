import 'package:flutter/material.dart';
class AppColors {
  static const Color yellow = Color(0xFFFFBA08);
  static const Color amber = Color(0xFFFAA307);
  static const Color orange = Color(0xFFF48C06);
  static const Color deepOrange = Color(0xFFE85D04);
  static const Color darkNavy = Color(0xFF03071E); // Couleur principale / Fond sombre
  static const Color errorRed = Color(0xFFB00020);
  
  static const Color surfaceLight = Color(0xFFF2F0EF);
  static const Color white = Colors.white;
}

final appTheme = ThemeData(
  useMaterial3: true,
  
  // 1. ColorScheme principal
  colorScheme: const ColorScheme.light(
    primary: AppColors.orange,
    secondary: AppColors.amber,
    tertiary: AppColors.yellow,
    surface: AppColors.surfaceLight,
    onPrimary: AppColors.white,
    onSecondary: AppColors.darkNavy,
    onSurface: AppColors.darkNavy,
    error: AppColors.errorRed,
    onError: AppColors.white,
  ),

  // 2. Scaffold (Fond de page)
  scaffoldBackgroundColor: AppColors.surfaceLight,

  // 3. Textes
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.darkNavy, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: AppColors.darkNavy, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: AppColors.darkNavy, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.darkNavy, fontSize: 14),
    labelLarge: TextStyle(color: AppColors.darkNavy, fontWeight: FontWeight.w500),
  ),

  // 4. TextField (InputDecoration)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.amber, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.amber, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.deepOrange, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
    ),
    labelStyle: const TextStyle(color: AppColors.darkNavy),
    floatingLabelStyle: const TextStyle(color: AppColors.deepOrange, fontWeight: FontWeight.w600),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),

  // 5. IconButton
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: AppColors.amber,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: Colors.grey.shade300,
      disabledForegroundColor: Colors.grey.shade600,
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(14),
    ),
  ),

  // 5bis. Icon
  iconTheme: IconThemeData(
    size: 24,
  ),

  // 6. FilterChip (et Chips en général)
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.white,
    disabledColor: Colors.grey.shade200,
    selectedColor: AppColors.amber,
    secondarySelectedColor: AppColors.deepOrange,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: const TextStyle(color: AppColors.darkNavy, fontWeight: FontWeight.w500),
    secondaryLabelStyle: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w500),
    brightness: Brightness.light,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Colors.grey, width: 1),
    ),
    checkmarkColor: AppColors.white,
  ),

  // 7. ListTile
  listTileTheme: ListTileThemeData(
    tileColor: AppColors.white,
    selectedTileColor: AppColors.yellow.withOpacity(0.15),
    iconColor: AppColors.amber,
    textColor: AppColors.darkNavy,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  ),

  // 8. Checkbox
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.grey.shade300;
      }
      if (states.contains(WidgetState.selected)) {
        return AppColors.amber;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(AppColors.white),
    side: const BorderSide(color: AppColors.darkNavy, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  ),

  //9. BottomAppBar
  bottomAppBarTheme: BottomAppBarThemeData(
    color: AppColors.amber
  ),

  //9bis AppBar
  appBarTheme: AppBarThemeData(
    backgroundColor: AppColors.surfaceLight,
  ),

  //10. ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.amber,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: Colors.grey.shade300,
      disabledForegroundColor: Colors.grey.shade600,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  // 11. AlertDialog
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    titleTextStyle: const TextStyle(
      color: AppColors.darkNavy,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(
      color: AppColors.darkNavy,
      fontSize: 15,
    ),
  ),

);