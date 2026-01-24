import 'package:fe/services/local_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static const String baseUrl = "http://localhost:9000/api"; // Use 'adb reverse tcp:9000 tcp:9000' for physical devices
  
  late Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ));

    // Add logging and auth interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));
    
    // Auth Interceptor: Menambahkan token JWT ke setiap request secara otomatis
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await LocalStorageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // Helper methods for GET, POST, etc.
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    return await dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await dio.post(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await dio.put(path, data: data, queryParameters: queryParameters, options: options);
  }
}
