import 'package:fe/presentation/pages/auth/login_pages.dart';
import 'package:fe/presentation/pages/auth/register_pages.dart';
import 'package:fe/presentation/pages/home/home_pages.dart';
import 'package:fe/presentation/pages/onboarding/get_started_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // daftar nama route
  static const getStartedPage = '/getStartedPage';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  // route generator opsional (lebih fleksible)
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case getStartedPage:
        return MaterialPageRoute(builder: (_) => const GetStartedPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPages());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPages());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 - Page Not Found'))),
        );
    }
  }
}
