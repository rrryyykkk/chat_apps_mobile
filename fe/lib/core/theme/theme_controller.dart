import 'package:fe/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  static Future<void> init() async {
    final isDark = await LocalStorageService.getDarkMode();
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static void toggleTheme(bool isDark) {
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
    LocalStorageService.setDarkMode(isDark);
  }
}
