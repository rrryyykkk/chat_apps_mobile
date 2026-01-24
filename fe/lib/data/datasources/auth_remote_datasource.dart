import 'package:fe/core/network/api_client.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<Response> login(String email, String password) async {
    return await apiClient.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register(String email, String password, String name, String color) async {
    return await apiClient.post('/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
      'color': color,
    });
  }
}
