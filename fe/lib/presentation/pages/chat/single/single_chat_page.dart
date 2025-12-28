import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/presentation/widgets/chat/chat_bubble.dart';
import 'package:fe/presentation/widgets/chat/chat_header.dart';
import 'package:fe/presentation/widgets/chat/chat_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [SingleChatPage] menampilkan percakapan personal antara dua pengguna.
/// Halaman ini menangani pengiriman pesan, pembaruan status pesan (sending, sent, delivered, read),
/// serta fitur lanjutan seperti Balas (Reply), Edit, dan Hapus pesan.
class SingleChatPage extends StatefulWidget {
  final Chat chat;
  const SingleChatPage({super.key, required this.chat});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  // Kontroller teks untuk area input pesan
  final TextEditingController _msgController = TextEditingController();
  
  // State untuk menyimpan pesan yang sedang dibalas atau diedit
  Message? _replyMessage;
  Message? _editingMessage;

  // Pesan Dummy
  final List<Message> _messages = [
    Message(
      id: "1",
      senderId: "me",
      content: "Halo mas",
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      status: MessageStatus.read,
    ),
    Message(
      id: "2",
      senderId: "other",
      content: "Yoi mas, kenapa?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      status: MessageStatus.read,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Simulasi tandai pesan terbaca saat membuka halaman
    _markAsRead();
  }

  void _markAsRead() {
    // Simulasi delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        for (var msg in _messages) {
          if (msg.senderId == "other" && msg.status != MessageStatus.read) {
             // Di aplikasi nyata, update ke backend disini
          }
        }
      });
    });
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;

    if (_editingMessage != null) {
      // Logika Edit
      setState(() {
        _editingMessage!.content = _msgController.text;
        _editingMessage = null;
        _msgController.clear();
      });
      return;
    }

    final newMessage = Message(
      id: DateTime.now().toString(),
      senderId: "me",
      content: _msgController.text,
      timestamp: DateTime.now(),
      status: MessageStatus.sending, // Status awal sending
      replyToId: _replyMessage?.id,
    );

    setState(() {
      _messages.add(newMessage);
      _msgController.clear();
      _replyMessage = null;
    });

    // Simulasi pembaruan status
    _simulateMessageStatus(newMessage);
  }

  void _simulateMessageStatus(Message msg) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => msg.status = MessageStatus.sent);

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => msg.status = MessageStatus.delivered);

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => msg.status = MessageStatus.read);
  }

  void _showContextMenu(Message msg) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isMe = msg.senderId == "me";
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!msg.isDeleted) ...[
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text("Balas"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _replyMessage = msg);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("Salin"),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: msg.content));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Disalin!")));
                },
              ),
              if (isMe) ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Edit"),
                  onTap: () {
                    Navigator.pop(context);
                    // Cek batas waktu < 15 menit (misal)
                    final diff = DateTime.now().difference(msg.timestamp).inMinutes;
                    if (diff > 15) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tidak bisa edit pesan lebih dari 15 menit")));
                       return;
                    }
                    setState(() {
                      _editingMessage = msg;
                      _msgController.text = msg.content;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Hapus", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(msg);
                  },
                ),
              ],
            ],
            // Info selalu tersedia
             ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Info"),
              onTap: () {
                Navigator.pop(context);
                // Tampilkan dialog info
                _showMessageInfo(msg);
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _confirmDelete(Message msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Pesan?"),
        content: const Text("Apakah Anda yakin ingin menghapus pesan ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              // Soft delete (Hapus secara logika)
              setState(() {
                 // Karena msg sebenarnya reference, ubah propertynya lgsg akan update UI
                 // Tapi lebih baik cari index kalau di real app state management
                 // Disini msg adalah reference dr list _messages
                 // Namun Message immutable kecuali yg kita ubah tadi.
                 // Kita tadi ubah 'content' dan 'status' jadi mutable, tp 'isDeleted' masih final.
                 // Perlu ubah isDeleted jadi mutable di model dl atau replace object.
                 // Karena di model tadi isDeleted final, kita replace objectnya.
                 final index = _messages.indexWhere((m) => m.id == msg.id);
                 if (index != -1) {
                   _messages[index] = Message(
                     id: msg.id,
                     senderId: msg.senderId,
                     content: msg.content,
                     timestamp: msg.timestamp,
                     status: msg.status,
                     isDeleted: true,
                     replyToId: msg.replyToId,
                   );
                 }
              });
              Navigator.pop(ctx);
            }, 
            child: const Text("Hapus", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  void _showMessageInfo(Message msg) {
     showDialog(
       context: context,
       builder: (ctx) => AlertDialog(
         content: Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text("Sent: ${msg.timestamp}"),
             Text("Status: ${msg.status.name}"),
           ],
         ),
       )
     );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          ChatHeader(
            chat: widget.chat,
            onBackPressed: () => Navigator.pop(context),
            onMorePressed: () {},
            onCallPressed: () {},
            onVideoCallPressed: () {},
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return GestureDetector(
                  onLongPress: () => _showContextMenu(msg),
                  child: ChatBubble(
                    message: msg,
                    isSender: msg.senderId == "me",
                    isGroup: false, 
                  ),
                );
              },
            ),
          ),

          // Reply Preview
          if (_replyMessage != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                   const Icon(Icons.reply, color: AppColors.blue_500),
                   const SizedBox(width: 8),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("Replying to ${_replyMessage!.senderId == 'me' ? 'Yourself' : 'Other'}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.blue_500)),
                         Text(_replyMessage!.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                       ],
                     )
                   ),
                   IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _replyMessage = null)),
                ],
              ),
            ),
          
          // Edit Preview
           if (_editingMessage != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: AppColors.blue_500.withValues(alpha: 0.1),
              child: Row(
                children: [
                   const Icon(Icons.edit, color: AppColors.blue_500),
                   const SizedBox(width: 8),
                   const Expanded(child: Text("Editing message...", style: TextStyle(color: AppColors.blue_500, fontWeight: FontWeight.bold))),
                   IconButton(icon: const Icon(Icons.close), onPressed: () {
                     setState(() {
                       _editingMessage = null;
                       _msgController.clear();
                     });
                   }),
                ],
              ),
            ),

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
