import 'package:fe/config/app_color.dart';
import 'package:fe/config/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // light theme
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.blue_500,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.neutral_900),
      titleTextStyle: TextStyle(
        color: AppColors.neutral_900,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.blue_500,
      unselectedItemColor: AppColors.neutral_400,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutral_50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: AppColors.neutral_400),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.neutral_100,
      thickness: 1,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.blue_500,
      secondary: AppColors.blue_700,
      surface: AppColors.white,
      onPrimary: Colors.white,
      onSurface: AppColors.neutral_900,
    ),
    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.neutral_900,
      displayColor: AppColors.neutral_900,
    ),
  );

  // dark theme
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.blue_500,
    scaffoldBackgroundColor: AppColors.neutral_900,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.neutral_900,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.neutral_800,
      selectedItemColor: AppColors.blue_500,
      unselectedItemColor: AppColors.neutral_400,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutral_800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: AppColors.neutral_500),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.neutral_800,
      thickness: 1,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue_500,
      secondary: AppColors.blue_300,
      surface: AppColors.neutral_800,
      onPrimary: Colors.white,
      onSurface: AppColors.neutral_50,
    ),
    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.neutral_50,
      displayColor: AppColors.neutral_50,
    ),
  );
}
