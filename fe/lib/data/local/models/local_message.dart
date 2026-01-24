import 'package:isar/isar.dart';

part 'local_message.g.dart';

@collection
class LocalMessage {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String messageId; // ID from Backend

  @Index()
  late String chatId;

  late String senderId;
  late String content;
  late DateTime timestamp;
  
  String type = 'TEXT'; // TEXT, IMAGE, VIDEO, DOCUMENT
  String status = 'SENT'; // SENDING, SENT, DELIVERED, READ
  
  String? replyToId;
  
  // Local only field
  bool isSynced = true; 
}
