import 'package:fe/config/app_color.dart';
import 'package:fe/config/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // light theme
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.blue_500,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.blue_500,
      secondary: AppColors.blue_700,

      surface: AppColors.white,
      onPrimary: AppColors.neutral_900,
  
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
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue_500,
      secondary: AppColors.blue_300,
      surface: AppColors.neutral_800,
      onPrimary: AppColors.white,
      onSurface: AppColors.neutral_50,
    ),
    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.neutral_50,
      displayColor: AppColors.neutral_50,
    ),
  );
}
