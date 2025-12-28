import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/presentation/widgets/chat/chat_bubble.dart';
import 'package:fe/presentation/widgets/chat/chat_header.dart';
import 'package:fe/presentation/widgets/chat/chat_input.dart';
import 'package:flutter/material.dart';


/// [GroupChatPage] menampilkan percakapan grup dengan bubble berwarna variatif.
class GroupChatPage extends StatefulWidget {
  final Chat chat;
  const GroupChatPage({super.key, required this.chat});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _msgController = TextEditingController();
  
  // Pesan Dummy untuk grup
  final List<Message> _messages = [
    Message(
      id: "1",
      senderId: "u2",
      content: "Halo gays, mabar yu",
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Message(
      id: "2",
      senderId: "u3",
      content: "Gass login",
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    Message(
      id: "3",
      senderId: "me",
      content: "Bentar otww",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  // Map ID pengguna dummy ke pengguna & warna
  final Map<String, User> _groupMembers = {
    "u2": User(id: "u2", name: "Ucup", email: "ucup@mail.com", color: Colors.orange),
    "u3": User(id: "u3", name: "Asep", email: "asep@mail.com", color: Colors.purple),
  };

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(
        Message(
          id: DateTime.now().toString(),
          senderId: "me",
          content: _msgController.text,
          timestamp: DateTime.now(),
        ),
      );
      _msgController.clear();
    });
  }

  void _showMenu() {
    // Tampilkan bottom sheet menu samakan dgn single chat
      showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 250,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: GridView.count(
          crossAxisCount: 3, 
          padding: const EdgeInsets.all(24),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
             _buildMenuItem(Icons.insert_drive_file, "Document", Colors.indigo),
             _buildMenuItem(Icons.camera_alt, "Camera", Colors.pink),
             _buildMenuItem(Icons.photo, "Gallery", Colors.purple),
             _buildMenuItem(Icons.headset, "Audio", Colors.orange),
             _buildMenuItem(Icons.location_on, "Location", Colors.green),
             _buildMenuItem(Icons.person, "Contact", Colors.blue),
          ],
        ),
      ),
    );
  }

   Widget _buildMenuItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
             border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral_50,
      body: Column(
        children: [
          // Header
          ChatHeader(
            chat: widget.chat,
            onBackPressed: () => Navigator.pop(context),
            onMorePressed: () {},
            onCallPressed: () {},
            onVideoCallPressed: () {},
          ),

          // Daftar Pesan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.senderId == "me";
                
                // Ambil data pengirim
                final sender = _groupMembers[msg.senderId];

                return ChatBubble(
                  message: msg,
                  isSender: isMe,
                  isGroup: true,
                  senderName: sender?.name ?? "Unknown", // Tampilkan nama
                  groupMemberColor: sender?.color ?? AppColors.neutral_500, // Warna bubble
                );
              },
            ),
          ),

          // Input
          ChatInput(
            controller: _msgController,
            onSendPressed: _sendMessage,
            onMenuPressed: _showMenu,
          ),
        ],
      ),
    );
  }
}
