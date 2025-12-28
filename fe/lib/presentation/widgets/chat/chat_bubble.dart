import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:flutter/material.dart';

/// [ChatBubble] adalah widget untuk menampilkan satu balon pesan dalam percakapan.
/// Mendukung tampilan untuk pengirim (kanan) dan penerima (kiri).
/// - [isSender]: Menentukan style bubble (Kanan/Biru vs Kiri/Putih/Colored untuk grup).
/// - [isGroup]: Menentukan apakah pesan berasal dari percakapan grup.
/// - [senderName]: Nama pengirim (khusus untuk tampilan di grup).
/// - [groupMemberColor]: Warna background khusus (untuk membedakan member grup).
class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isSender;
  final bool isGroup;
  final String? senderName;
  final Color? groupMemberColor; // Warna bg khusus member grup

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    this.isGroup = false,
    this.senderName,
    this.groupMemberColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Tentukan warna background dan text
    Color bgColor;
    Color textColor;

    if (isSender) {
      bgColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onPrimary;
    } else {
      if (isGroup && groupMemberColor != null) {
         bgColor = groupMemberColor!;
         textColor = Colors.white; 
      } else {
        bgColor = theme.inputDecorationTheme.fillColor!;
        textColor = theme.colorScheme.onSurface;
      }
    }

    // Deleted Message UI
    if (message.isDeleted) {
       return Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSender ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerTheme.color!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.block, size: 16, color: AppColors.neutral_500),
              const SizedBox(width: 8),
              Text(
                "This message was deleted",
                style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSender ? 16 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 16),
          ),
          boxShadow: [
             if(!isSender) 
               BoxShadow(
                 color: Colors.black.withValues(alpha: theme.brightness == Brightness.light ? 0.05 : 0.2),
                 blurRadius: 2,
                 offset: const Offset(0, 1),
               )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Tampilkan nama pengirim di grup jika bukan kita
            if (isGroup && !isSender && senderName != null) ...[
              Text(
                senderName!,
                style: theme.textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isGroup ? Colors.white70 : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              message.content,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            // Timestamp & Status Icon
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2,'0')}",
                  style: theme.textTheme.labelSmall!.copyWith(
                    fontSize: 10,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
                if (isSender) ...[
                  const SizedBox(width: 4),
                  Icon(
                    _getStatusIcon(message.status),
                    size: 14,
                    color: message.status == MessageStatus.read ? AppColors.green_500 : Colors.white70,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
    }
  }
}
