import 'package:fe/core/network/api_client.dart';
import 'package:dio/dio.dart';

class MediaRemoteDataSource {
  final ApiClient apiClient;

  MediaRemoteDataSource(this.apiClient);

  Future<Response> uploadFile(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    return await apiClient.post('/media/upload', data: formData);
  }
}
