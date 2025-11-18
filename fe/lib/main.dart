import 'package:fe/config/app_theme.dart';
import 'package:fe/presentation/pages/onboarding/splash_page.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: const SplashPage(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
