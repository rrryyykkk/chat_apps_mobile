import 'package:fe/data/datasources/status_remote_datasource.dart';
import 'package:dio/dio.dart';

class StatusRepository {
  final StatusRemoteDataSource remoteDataSource;

  StatusRepository(this.remoteDataSource);

  Future<List<dynamic>> getStatuses() async {
    try {
      final response = await remoteDataSource.getStatuses();
      return response.data['data'] as List<dynamic>;
    } catch (e) {
      print("Get Statuses Failed: $e");
      return [];
    }
  }

  Future<bool> createTextStatus(String content, String color) async {
    try {
      await remoteDataSource.createStatus({
        'type': 'TEXT',
        'content': content,
        'color': color,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createMediaStatus(String url, String caption) async {
    try {
      await remoteDataSource.createStatus({
        'type': 'IMAGE',
        'mediaUrl': url,
        'content': caption,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
