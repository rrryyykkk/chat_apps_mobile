import 'package:fe/core/network/api_client.dart';
import 'package:fe/data/datasources/auth_remote_datasource.dart';
import 'package:fe/data/datasources/chat_remote_datasource.dart';
import 'package:fe/services/websocket_service.dart';

class ServiceLocator {
  static final ApiClient _apiClient = ApiClient();
  
  static final AuthRemoteDataSource authDataSource = AuthRemoteDataSource(_apiClient);
  static final ChatRemoteDataSource chatDataSource = ChatRemoteDataSource(_apiClient);
  static final WebSocketService webSocketService = WebSocketService();
}
