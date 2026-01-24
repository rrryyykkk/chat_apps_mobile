import 'package:easy_localization/easy_localization.dart';
import 'package:fe/config/app_theme.dart';
import 'package:fe/core/error/error_handler.dart';
import 'package:fe/core/theme/theme_controller.dart';
import 'package:fe/presentation/pages/onboarding/splash_page.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/presentation/widgets/common/global_error_widget.dart';
import 'package:fe/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initDependencies(); // Initialize DI
  await ThemeController.init(); // Initialize Theme from storage

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

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
        Locale('zh'),
        Locale('ar'),
        Locale('es'),
        Locale('ms'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
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
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
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
