import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class StatusDetailPage extends StatefulWidget {
  final String userName;
  final Color userColor;
  final bool isMyStatus;

  const StatusDetailPage({
    super.key,
    required this.userName,
    required this.userColor,
    this.isMyStatus = false,
  });

  @override
  State<StatusDetailPage> createState() => _StatusDetailPageState();
}

class _StatusDetailPageState extends State<StatusDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLiked = false;

  // Dummy list penonton untuk "My Status"
  final List<Map<String, dynamic>> _viewers = [
    {"name": "Jane Cooper", "time": DateTime.now().subtract(const Duration(minutes: 5)), "liked": true},
    {"name": "Floyd Miles", "time": DateTime.now().subtract(const Duration(minutes: 15)), "liked": false},
    {"name": "Ronald Richards", "time": DateTime.now().subtract(const Duration(hours: 2)), "liked": true},
    {"name": "Esther Howard", "time": DateTime.now().subtract(const Duration(minutes: 45)), "liked": false},
  ];

  @override
  void initState() {
    super.initState();
    
    // Urutkan penonton: Likes dulu, baru waktu tercepat
    _viewers.sort((a, b) {
      if (a['liked'] != b['liked']) {
        return a['liked'] ? -1 : 1;
      }
      return (a['time'] as DateTime).compareTo(b['time'] as DateTime);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
      }
    });

    _controller.forward();
  }

  String _getTimeString(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inHours < 1) {
      return "${diff.inMinutes} minutes ago";
    } else {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // Swipe down to close
        if (details.delta.dy > 10) {
          Navigator.pop(context);
        }
        // Swipe up to show viewers (only for My Status)
        if (details.delta.dy < -10 && widget.isMyStatus) {
          _controller.stop();
          _showViewersSheet();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
        children: [
          // Status Content (Dummy Image representation)
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.userColor,
                    widget.userColor.withValues(alpha: 0.5),
                    Colors.black,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image, size: 100, color: Colors.white.withValues(alpha: 0.3)),
                    const SizedBox(height: 20),
                    Text(
                      "Status Content for ${widget.userName}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Progress Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Header Info
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: widget.userColor.withValues(alpha: 0.3),
                        child: Text(
                          widget.userName[0],
                          style: TextStyle(color: widget.userColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Just now",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Actions
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isMyStatus) ...[
                      // Penonton list handle
                      GestureDetector(
                        onTap: () {
                           _controller.stop();
                           _showViewersSheet();
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                            Text(
                              "${_viewers.length} Viewers",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!widget.isMyStatus) ...[
                           Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _controller.stop();
                                _showReplyDialog();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.keyboard_arrow_up, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text("Reply", style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              setState(() => _isLiked = !_isLiked);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked ? Colors.red : Colors.white,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _showViewersSheet() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.dividerTheme.color, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Viewed by ${_viewers.length}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _viewers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final v = _viewers[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: widget.userColor.withValues(alpha: 0.1),
                    child: Text(v['name'][0], style: TextStyle(color: widget.userColor)),
                  ),
                  title: Text(v['name'], style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                  subtitle: Text(_getTimeString(v['time']), style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6))),
                  trailing: v['liked'] ? const Icon(Icons.favorite, color: Colors.red, size: 20) : null,
                );
              },
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      if (mounted) _controller.forward();
    });
  }

  void _showReplyDialog() {
    final theme = Theme.of(context);
    final replyController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: replyController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Type a reply...",
                    hintStyle: theme.inputDecorationTheme.hintStyle,
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.blue_500),
                onPressed: () {
                  if (replyController.text.trim().isNotEmpty) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Reply sent!")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      if (mounted) _controller.forward();
    });
  }
}
