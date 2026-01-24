import 'package:fe/core/network/api_client.dart';
import 'package:dio/dio.dart';

class ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSource(this.apiClient);

  Future<Response> getChats() async {
    return await apiClient.get('/chats/');
  }

  Future<Response> getMessages(String chatId) async {
    return await apiClient.get('/chats/$chatId/messages');
  }

  Future<Response> createGroup(String name, List<String> userIds) async {
    return await apiClient.post('/chats/groups', data: {
      'name': name,
      'userIds': userIds,
    });
  }

  Future<Response> createDirectChat(String contactUserId) async {
    return await apiClient.post('/chats/direct', data: {
      'contactUserId': contactUserId,
    });
  }
}
