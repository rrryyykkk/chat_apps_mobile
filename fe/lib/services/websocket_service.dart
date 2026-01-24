import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  // Use localhost - works with adb reverse tcp:9000 tcp:9000
  final String _url = "ws://localhost:9000/ws";
  
  void connect(String userId, String token) {
    if (_channel != null) return;

    try {
      final wsUrl = Uri.parse("$_url?userId=$userId&token=$token");
      _channel = WebSocketChannel.connect(wsUrl);
      debugPrint("[WS] Connecting as user: $userId to $_url");
      
      // Listen for connection errors
      _channel!.stream.handleError((error) {
        debugPrint("[WS] Error: $error");
      });
    } catch (e) {
      debugPrint("[WS] Connection failed: $e");
    }
  }

  Stream get messages => _channel?.stream ?? const Stream.empty();

  void sendMessage(String type, String chatId, String content, {dynamic data}) {
    if (_channel != null) {
      final msg = jsonEncode({
        'type': type,
        'chatId': chatId,
        'content': content,
        'data': data,
      });
      _channel!.sink.add(msg);
      debugPrint("[WS] Message sent: $type");
    }
  }

  void close() {
    _channel?.sink.close();
    debugPrint("[WS] Connection closed");
  }
}
