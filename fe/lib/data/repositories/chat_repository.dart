import 'package:fe/data/datasources/chat_remote_datasource.dart';
import 'package:fe/data/local/models/local_chat.dart';
import 'package:fe/data/local/models/local_message.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/services/isar_service.dart';
import 'package:isar/isar.dart';

class ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final IsarService isarService;

  ChatRepository(this.remoteDataSource, this.isarService);

  // Sync All Chats (List)
  Future<void> syncChats() async {
    try {
      final response = await remoteDataSource.getChats();
      final List<dynamic> data = response.data['data'];

      final isar = await isarService.db;
      
      await isar.writeTxn(() async {
        for (var item in data) {
          final chatId = item['id'];
          var localChat = await isar.localChats.filter().chatIdEqualTo(chatId).findFirst();
          localChat ??= LocalChat(); // Create new if not exists

          localChat.chatId = chatId;
          localChat.name = item['name'];
          localChat.icon = item['icon'];
          localChat.isGroup = item['isGroup'] ?? false;
          localChat.updatedAt = DateTime.tryParse(item['updatedAt'] ?? '');
          
          // Last Message Info (if available from API list)
          // localChat.lastMessageContent = ... 
          
          await isar.localChats.put(localChat);
        }
      });
    } catch (e) {
      print("Sync Chats Failed: $e");
    }
  }

  // Sync Messages for a Chat
  Future<void> syncMessages(String chatId) async {
    try {
      final response = await remoteDataSource.getMessages(chatId);
      final List<dynamic> data = response.data['data'];

      final isar = await isarService.db;
      
      await isar.writeTxn(() async {
        for (var item in data) {
          final messageId = item['id'];
          var localMsg = await isar.localMessages.filter().messageIdEqualTo(messageId).findFirst();
          localMsg ??= LocalMessage();

          localMsg.messageId = messageId;
          localMsg.chatId = chatId;
          localMsg.senderId = item['senderId'];
          localMsg.content = item['content'];
          localMsg.timestamp = DateTime.parse(item['timestamp']);
          localMsg.type = item['type'] ?? 'TEXT';
          localMsg.status = item['status'] ?? 'SENT';
          localMsg.replyToId = item['replyToId'];
          localMsg.isSynced = true;

          await isar.localMessages.put(localMsg);
        }
      });
    } catch (e) {
         print("Sync Messages Failed: $e");
    }
  }

  // Send Message (Online) -> Save Local
  Future<void> sendMessage(String chatId, String content) async {
     // 1. Send to API (Assume API returns the created message)
    // await remoteDataSource.sendMessage(...) 
    // For now we just implement the sync logic.
  }

  // Create Group
  Future<void> createGroup(String name, List<String> userIds) async {
    await remoteDataSource.createGroup(name, userIds);
    await syncChats(); // Refresh local chats after creation
  }

  // Listen to Chats
  Stream<List<LocalChat>> listenChats() async* {
    final isar = await isarService.db;
    yield* isar.localChats.where().sortByUpdatedAtDesc().watch(fireImmediately: true);
  }

  // Create or Get Direct Chat with a contact
  Future<Chat?> createOrGetDirectChat(String contactUserId) async {
    try {
      // Call backend API to create or get existing 1-on-1 chat
      final response = await remoteDataSource.createDirectChat(contactUserId);
      
      if (response.statusCode == 200) {
        final chatData = response.data['data'];
        
        // Sync this chat to local DB
        final isar = await isarService.db;
        await isar.writeTxn(() async {
          var localChat = await isar.localChats.filter().chatIdEqualTo(chatData['id']).findFirst();
          localChat ??= LocalChat();
          
          localChat.chatId = chatData['id'];
          localChat.name = chatData['name'];
          localChat.icon = chatData['icon'];
          localChat.isGroup = chatData['isGroup'] ?? false;
          localChat.updatedAt = DateTime.tryParse(chatData['updatedAt'] ?? '');
          
          await isar.localChats.put(localChat);
        });
        
        // Return Chat object for navigation
        return Chat(
          id: chatData['id'],
          name: chatData['name'] ?? 'Unknown',
          isGroup: chatData['isGroup'] ?? false,
          icon: chatData['icon'],
          participants: [],
        );
      }
      return null;
    } catch (e) {
      print("Create/Get Direct Chat Failed: $e");
      return null;
    }
  }

  // Listen to Messages in a Chat
  Stream<List<LocalMessage>> listenMessages(String chatId) async* {
    final isar = await isarService.db;
    yield* isar.localMessages.filter().chatIdEqualTo(chatId).sortByTimestamp().watch(fireImmediately: true);
  }
}
