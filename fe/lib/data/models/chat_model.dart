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
  final bool isDeleted;
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
}
