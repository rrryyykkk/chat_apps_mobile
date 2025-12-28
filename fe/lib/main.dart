import 'package:fe/config/app_theme.dart';
import 'package:fe/core/error/error_handler.dart';
import 'package:fe/core/theme/theme_controller.dart';
import 'package:fe/presentation/pages/onboarding/splash_page.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/presentation/widgets/common/global_error_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  // Tangkap Error Flutter (Masalah Rendering, Build Widget)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    ErrorHandler.log(details.exception, details.stack);
    // Tampilkan halaman error yang ramah user (bukan Layar Merah) di Mode Release
    if (kReleaseMode) {
      runApp(GlobalErrorApp(details: details));
    }
  };

  // Tangkap Error Async (Future, Stream, Network)
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorHandler.log(error, stack);
    return true; // Error sudah ditangani
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          themeAnimationDuration: const Duration(milliseconds: 600),
          themeAnimationCurve: Curves.easeInOut,
          home: const SplashPage(),
          onGenerateRoute: AppRoutes.generateRoute,
          builder: (context, child) {
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              return GlobalErrorWidget(errorDetails: errorDetails);
            };
            return child!;
          },
        );
      },
    );
  }
}

class GlobalErrorApp extends StatelessWidget {
  final FlutterErrorDetails details;
  const GlobalErrorApp({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GlobalErrorWidget(errorDetails: details),
    );
  }
}
