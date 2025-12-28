import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/core/widgets/custom_image.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  // Dummy data untuk chat list
  final List<Chat> _chats = [
    Chat(
      id: "1",
      name: "Dumb Ways to Die",
      isGroup: true,
      unreadCount: 3,
      lastMessage: Message(
        id: "m1",
        senderId: "u2",
        content: "Siapa itu??",
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ),
    Chat(
      id: "2",
      name: "Ucup Surucup",
      isGroup: false,
      unreadCount: 1,
      lastMessage: Message(
        id: "m2",
        senderId: "u3",
        content: "Besok jadi futsal gak?",
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ),
    Chat(
      id: "3",
      name: "Kois",
      isGroup: false,
      unreadCount: 0,
      lastMessage: Message(
        id: "m3",
        senderId: "u3",
        content: "Otw bang",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ListView.separated(
        itemCount: _chats.length,
        separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            onTap: () {
              // Navigasi ke Single atau Group chat sesuai tipe
              if (chat.isGroup) {
                Navigator.pushNamed(context, AppRoutes.groupChat, arguments: chat);
              } else {
                Navigator.pushNamed(context, AppRoutes.singleChat, arguments: chat);
              }
            },
            leading: GestureDetector(
              onTap: () {
                 Navigator.pushNamed(context, AppRoutes.chatInfo, arguments: chat);
              },
              child: Stack(
                children: [
                  CustomImage(
                    url: chat.icon,
                    width: 50,
                    height: 50,
                    radius: 25,
                  ),
                  // Online indicator (simulasi)
                  if (!chat.isGroup)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.green_500,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            title: Text(
              chat.name,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              chat.lastMessage?.content ?? "No messages yet",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: chat.unreadCount > 0
                        ? theme.colorScheme.onSurface
                        : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                    fontWeight: chat.unreadCount > 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  // Format simple untuk jam
                  "${chat.lastMessage?.timestamp.hour}:${chat.lastMessage?.timestamp.minute.toString().padLeft(2, '0')}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: chat.unreadCount > 0
                            ? AppColors.blue_500
                            : AppColors.neutral_400,
                      ),
                ),
                const SizedBox(height: 6),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.blue_500,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
