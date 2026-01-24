import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/presentation/widgets/chat/chat_bubble.dart';
import 'package:fe/presentation/widgets/chat/chat_header.dart';
import 'package:fe/presentation/widgets/chat/chat_input.dart';
import 'package:fe/core/network/service_locator.dart';
import 'package:fe/services/local_storage_service.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
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

  List<Message> _messages = [];
  bool _isLoadingMessages = true;

  String? _myId;

  @override
  void initState() {
    super.initState();
    _loadUserAndInit();
    _fetchMessages();
  }

  Future<void> _loadUserAndInit() async {
    final userId = await LocalStorageService.getUserId();
    final token = await LocalStorageService.getToken();
    
    if (userId != null && token != null) {
      _myId = userId;
      ServiceLocator.webSocketService.connect(userId, token);
    }
    _initWebSocket();
  }

  Future<void> _fetchMessages() async {
    setState(() => _isLoadingMessages = true);
    try {
      final response = await ServiceLocator.chatDataSource.getMessages(widget.chat.id);
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        setState(() {
          _messages = data.map((e) => Message.fromJson(e)).toList();
          _isLoadingMessages = false;
        });
        _markAsRead();
      }
    } catch (e) {
      setState(() => _isLoadingMessages = false);
      Fluttertoast.showToast(
        msg: "Failed to load messages",
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
    }
  }

  void _initWebSocket() {
    if (_myId == null) return;
    
    ServiceLocator.webSocketService.messages.listen((event) {
      final msgData = jsonDecode(event);
      
      if (msgData['type'] == 'chat' && msgData['chatId'] == widget.chat.id) {
        final newMessage = Message.fromJson(msgData['data']);
        
        setState(() {
          // Find temporary message by matching content and sender
          final index = _messages.indexWhere((m) => 
            m.senderId == newMessage.senderId && 
            m.content == newMessage.content && 
            m.status == MessageStatus.sending
          );
          
          if (index != -1) {
            // Replace temporary message with real one from server
            _messages[index] = newMessage;
          } else if (newMessage.senderId != _myId) {
            // Message from other user, add it to bottom (index 0)
            _messages.insert(0, newMessage);
          }
        });
      } else if (msgData['type'] == 'status_update') {
        final updatedMsg = Message.fromJson(msgData['data']);
        setState(() {
          final index = _messages.indexWhere((m) => m.id == updatedMsg.id);
          if (index != -1) {
            _messages[index].status = updatedMsg.status;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    ServiceLocator.webSocketService.close();
    super.dispose();
  }

  void _markAsRead() {
    if (_myId == null) return;
    // Kirim laporan baca jika ada pesan yang belum dibaca dari orang lain
    for (var msg in _messages) {
      if (msg.senderId != _myId && msg.status != MessageStatus.read) {
         ServiceLocator.webSocketService.sendMessage("read_receipt", widget.chat.id, "", data: msg.id);
      }
    }
  }

  void _sendMessage() async {
    if (_msgController.text.trim().isEmpty || _myId == null) return;

    if (_editingMessage != null) {
      // Logika edit melalui WS atau REST
      setState(() {
        _editingMessage!.content = _msgController.text;
        _editingMessage = null;
        _msgController.clear();
      });
      return;
    }

    final content = _msgController.text;

    // Tambahkan secara lokal untuk UI optimis
    final newMessage = Message(
      id: "temp_${DateTime.now().millisecondsSinceEpoch}",
      senderId: _myId!,
      content: content,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      replyToId: _replyMessage?.id,
    );

    setState(() {
      // Insert di index 0 agar muncul paling bawah (karena ListView reverse: true)
      _messages.insert(0, newMessage);
      _msgController.clear();
      _replyMessage = null;
    });

    // Kirim via WebSocket
    ServiceLocator.webSocketService.sendMessage(
      "chat", 
      widget.chat.id, 
      content,
      data: _replyMessage?.id, // Kirim ID pesan yang dibalas sebagai data tambahan
    );
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
                title: const Text("Reply"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _replyMessage = msg);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("Copy"),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: msg.content));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied!")));
                },
              ),
              if (isMe) ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Edit"),
                  onTap: () {
                    Navigator.pop(context);
                    // Check 15 mins limit
                    final diff = DateTime.now().difference(msg.timestamp).inMinutes;
                    if (diff > 15) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot edit messages older than 15 minutes")));
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
                  title: const Text("Delete", style: TextStyle(color: Colors.red)),
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
        title: const Text("Delete Message?"),
        content: const Text("Are you sure you want to delete this message?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
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
            child: const Text("Delete", style: TextStyle(color: Colors.red))
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
            child: _isLoadingMessages 
              ? const Center(child: CircularProgressIndicator())
              : _messages.isEmpty 
                ? const Center(child: Text("No messages yet. Say hi!"))
                : ListView.builder(
                    reverse: true, // List dibalik: Index 0 ada di bawah
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      // Backend mengirim DESC (index 0 = terbaru).
                      // Karena reverse: true, item index 0 dirender di bawah.
                      // Jadi kita TIDAK perlu membalik index lagi.
                      final msg = _messages[index];
                      return GestureDetector(
                        onLongPress: () => _showContextMenu(msg),
                        child: ChatBubble(
                          message: msg,
                          isSender: msg.senderId == _myId,
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
