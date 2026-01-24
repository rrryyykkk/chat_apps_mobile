import 'package:fe/core/network/api_client.dart';
import 'package:dio/dio.dart';

class ContactRemoteDataSource {
  final ApiClient apiClient;

  ContactRemoteDataSource(this.apiClient);

  Future<Response> addContact(String email, String alias) async {
    return await apiClient.post('/contacts/add', data: {
      'email': email,
      'alias': alias,
    });
  }

  Future<Response> getContacts() async {
    return await apiClient.get('/contacts/');
  }
}
