import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';

/// [ChatHeader] adalah widget kustom untuk header di halaman chat.
/// Layout ini dibagi menjadi 2 baris:
/// - Baris 1: Tombol Back, Judul (Type), Tombol More.
/// - Baris 2: Avatar, Nama User/Grup, Kontak Info (Email/Phone), Tombol Call & VC.
class ChatHeader extends StatelessWidget {
  final Chat chat;
  final VoidCallback onBackPressed;
  final VoidCallback onMorePressed;
  final VoidCallback onCallPressed;
  final VoidCallback onVideoCallPressed;

  const ChatHeader({
    super.key,
    required this.chat,
    required this.onBackPressed,
    required this.onMorePressed,
    required this.onCallPressed,
    required this.onVideoCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.light ? 0.05 : 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // === BARIS 1: Navigasi ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onBackPressed,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
              ),
              Text(
                chat.isGroup ? "Group Chat" : "Message",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: onMorePressed,
                icon: Icon(
                  Icons.more_horiz, // Titik 3
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // === BARIS 2: Info User & Action ===
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.blue_500.withValues(alpha: 0.1),
                backgroundImage: chat.icon != null
                    ? NetworkImage(chat.icon!)
                    : null,
                child: chat.icon == null
                    ? Icon(
                        chat.isGroup ? Icons.group : Icons.person,
                        color: AppColors.blue_500,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Info (Nama & Email/Phone)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.chatInfo,
                      arguments: chat,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!chat.isGroup) ...[
                        const SizedBox(height: 2),
                        Text(
                          // Placeholder email/phone jika single chat
                          "user@email.com",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Actions (Call & VC)
              IconButton(
                onPressed: onCallPressed,
                icon: const Icon(
                  Icons.call_outlined,
                  color: AppColors.blue_500,
                ),
              ),
              IconButton(
                onPressed: onVideoCallPressed,
                icon: const Icon(
                  Icons.videocam_outlined,
                  color: AppColors.blue_500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
