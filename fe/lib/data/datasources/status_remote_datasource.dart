import 'package:fe/core/network/api_client.dart';
import 'package:dio/dio.dart';

class StatusRemoteDataSource {
  final ApiClient apiClient;

  StatusRemoteDataSource(this.apiClient);

  Future<Response> getStatuses() async {
    return await apiClient.get('/status/');
  }

  Future<Response> createStatus(Map<String, dynamic> data) async {
    return await apiClient.post('/status/', data: data);
  }

  Future<Response> likeStatus(String statusId) async {
    return await apiClient.post('/status/$statusId/like');
  }

  Future<Response> viewStatus(String statusId) async {
    return await apiClient.post('/status/$statusId/view');
  }
}
