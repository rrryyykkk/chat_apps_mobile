import 'package:fe/config/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// [ChatInput] widget untuk area input pesan di bawah (footer).
class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendPressed;
  final VoidCallback onMenuPressed; // Utk tombol +

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSendPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.light ? 0.05 : 0.2),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Tombol + (Menu)
            IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(
                Icons.add,
                color: AppColors.blue_500,
                size: 28,
              ),
            ),
            
            // Input Field
            Expanded(
              child: TextFormField(
                controller: controller,
                maxLines: 5, // Limit height to 5 lines then scroll
                minLines: 1,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                enableInteractiveSelection: true,
                autocorrect: true,
                enableSuggestions: true,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: "type_message_hint".tr(),
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                  filled: true,
                  isDense: true, // Important for fitting content
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Tombol Send
            GestureDetector(
              onTap: onSendPressed,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.blue_500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
