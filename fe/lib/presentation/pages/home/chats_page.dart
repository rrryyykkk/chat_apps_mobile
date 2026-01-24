import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/services/local_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fe/data/local/models/local_chat.dart';
import 'package:fe/data/repositories/chat_repository.dart';
import 'package:fe/injection.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/core/widgets/custom_image.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  final String searchQuery;
  const ChatsPage({super.key, this.searchQuery = ""});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late Future<bool> _hideChatFuture;
  late Stream<List<LocalChat>> _chatsStream;

  @override
  void initState() {
    super.initState();
    _initData();
    // Trigger sync in background
    locator<ChatRepository>().syncChats();
  }

  void _initData() {
    _hideChatFuture = LocalStorageService.getHideChatHistory();
    _chatsStream = locator<ChatRepository>().listenChats();
  }

  Future<void> _refreshChats() async {
    await locator<ChatRepository>().syncChats();
    // Re-initialize settings if they might have changed
    setState(() {
      _initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<bool>(
        future: _hideChatFuture,
        builder: (context, hideSnapshot) {
          final isHidden = hideSnapshot.data ?? false;
          if (isHidden) {
            return Center(child: Text("chat_history_hidden".tr()));
          }

          return StreamBuilder<List<LocalChat>>(
            stream: _chatsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              var chats = snapshot.data ?? [];

              // Filter locally
              if (widget.searchQuery.isNotEmpty) {
                final query = widget.searchQuery.toLowerCase();
                chats = chats.where((c) => 
                  (c.name?.toLowerCase().contains(query) ?? false) || 
                  (c.lastMessageContent?.toLowerCase().contains(query) ?? false)
                ).toList();
              }

              if (chats.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("no_conversations".tr()),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _initData, // Refresh settings and lists
                        child: Text("refresh_btn".tr())
                      )
                    ],
                  )
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshChats,
                child: ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 72),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onTap: () {
                        // Convert LocalChat to Chat model for navigation
                        final chatModel = Chat(
                          id: chat.chatId!,
                          name: chat.name ?? "Unknown",
                          icon: chat.icon,
                          isGroup: chat.isGroup ?? false,
                          participants: [], // Participants not needed for list view, will be loaded in detail
                        );
                        Navigator.pushNamed(context, AppRoutes.singleChat, arguments: chatModel);
                      },
                      leading: CustomImage(
                          url: chat.icon,
                          width: 50,
                          height: 50,
                          radius: 25,
                        ),
                      title: Text(
                        chat.name ?? "unknown_user".tr(),
                        style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        chat.lastMessageContent ?? "no_messages".tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                          chat.updatedAt != null ? 
                          "${chat.updatedAt!.hour}:${chat.updatedAt!.minute.toString().padLeft(2, '0')}" : "",
                          style: theme.textTheme.bodySmall,
                        ),
                    );
                  },
                ),
              );
            },
          );
        }
      ),
    );
  }
}
