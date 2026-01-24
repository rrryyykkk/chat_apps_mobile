import 'package:isar/isar.dart';

part 'local_chat.g.dart';

@collection
class LocalChat {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String chatId; // ID from Backend

  String? name;
  String? icon;
  bool isGroup = false;
  
  DateTime? updatedAt;
  
  // Last message preview (for chat list)
  String? lastMessageContent;
  String? lastMessageType;
  DateTime? lastMessageTime;
  String? lastMessageSenderName;
  
  // Participants stored as list of IDs or JSON
  List<String> participantIds = [];
}
