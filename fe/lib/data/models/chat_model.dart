import 'package:flutter/material.dart';

/// [User] model merepresentasikan pengguna aplikasi.
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final Color? color; // Warna unik untuk user di grup (bubble chat)

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.color,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      color: json['color'] != null ? Color(int.parse(json['color'].toString().replaceFirst('#', '0xff'))) : null,
    );
  }
}

/// [MessageType] enum untuk membedakan tipe pesan.
enum MessageType { text, image, info }

/// [MessageStatus] enum untuk status pengiriman.
enum MessageStatus { sending, sent, delivered, read }

/// [Message] model merepresentasikan satu pesan dalam chat.
class Message {
  final String id;
  final String senderId;
  String content; // Mutable agar bisa diedit
  final DateTime timestamp;
  final MessageType type;
  MessageStatus status; // Mutable untuk simulasi update status
  bool isDeleted; // Mutable for delete action
  final String? replyToId; // ID pesan yang dibalas

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.read,
    this.isDeleted = false,
    this.replyToId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: _parseMessageType(json['type']),
      status: _parseMessageStatus(json['status']),
      isDeleted: json['isDeleted'] ?? false,
      replyToId: json['replyToId'],
    );
  }

  static MessageType _parseMessageType(String? type) {
    switch (type) {
      case 'IMAGE': return MessageType.image;
      case 'INFO': return MessageType.info;
      default: return MessageType.text;
    }
  }

  static MessageStatus _parseMessageStatus(String? status) {
    switch (status) {
      case 'SENDING': return MessageStatus.sending;
      case 'SENT': return MessageStatus.sent;
      case 'DELIVERED': return MessageStatus.delivered;
      case 'READ': return MessageStatus.read;
      default: return MessageStatus.sent;
    }
  }
}

/// [Chat] model merepresentasikan room chat (bisa single atau group).
class Chat {
  final String id;
  final String name; // Nama user lain (single) atau nama grup (group)
  final String? icon; // URL icon/avatar
  final bool isGroup;
  final List<User> participants;
  final Message? lastMessage;
  final int unreadCount;

  Chat({
    required this.id,
    required this.name,
    this.icon,
    this.isGroup = false,
    this.participants = const [],
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'] ?? "Unknown",
      icon: json['icon'],
      isGroup: json['isGroup'] ?? false,
      unreadCount: json['unreadCount'] ?? 0,
      lastMessage: json['messages'] != null && (json['messages'] as List).isNotEmpty 
          ? Message.fromJson(json['messages'][0]) 
          : null,
    );
  }
}
