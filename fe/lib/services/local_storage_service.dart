import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class LocalStorageService {
  static const _storage = FlutterSecureStorage();
  
  static const String _tokenKey = 'access_token';
  static const String _userKey = 'user_data';
  static const String _userIdKey = 'user_id';
  static const String _muteNotificationsKey = 'mute_notifications';
  static const String _hideChatHistoryKey = 'hide_chat_history';
  static const String _hideStatusUpdatesKey = 'hide_status_updates';
  static const String _darkModeKey = 'dark_mode';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: _userKey, value: jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: _userKey);
    if (data == null) return null;
    return jsonDecode(data);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Settings
  static Future<void> setMuteNotifications(bool value) async {
    await _storage.write(key: _muteNotificationsKey, value: value.toString());
  }

  static Future<bool> getMuteNotifications() async {
    final val = await _storage.read(key: _muteNotificationsKey);
    return val == 'true';
  }

  static Future<void> setHideChatHistory(bool value) async {
    await _storage.write(key: _hideChatHistoryKey, value: value.toString());
  }

  static Future<bool> getHideChatHistory() async {
    final val = await _storage.read(key: _hideChatHistoryKey);
    return val == 'true';
  }

  static Future<void> setHideStatusUpdates(bool value) async {
    await _storage.write(key: _hideStatusUpdatesKey, value: value.toString());
  }

  static Future<bool> getHideStatusUpdates() async {
    final val = await _storage.read(key: _hideStatusUpdatesKey);
    return val == 'true';
  }

  static Future<void> setDarkMode(bool value) async {
    await _storage.write(key: _darkModeKey, value: value.toString());
  }

  static Future<bool> getDarkMode() async {
    final val = await _storage.read(key: _darkModeKey);
    return val == 'true';
  }
}
