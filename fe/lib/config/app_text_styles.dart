import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
    ),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
    labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  );
}
