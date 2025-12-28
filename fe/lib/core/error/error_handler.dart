import 'package:flutter/foundation.dart';
import 'errors.dart';
import 'failures.dart';

class ErrorHandler {
  static String interpret(dynamic error) {
    if (error is Failure) {
      return error.message;
    } else if (error is ServerException) {
      return "Server is currently unable to process your request.";
    } else if (error is CacheException) {
      return "Failed to load local data.";
    } else if (error is FormatException) {
      return "Data format usage error.";
    } else {
      // Log error asli untuk developer (mode debug)
      if (kDebugMode) {
        print("Unknown Error: $error");
      }
      return "Terjadi kesalahan. Silakan coba lagi nanti.";
    }
  }

  static void log(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      print("ERROR: $error");
      if (stackTrace != null) {
        print("STACKTRACE: $stackTrace");
      }
    }
    // Disini bisa kirim ke Sentry/Firebase Crashlytics untuk aplikasi real
  }
}
