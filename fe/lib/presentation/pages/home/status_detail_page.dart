import 'package:fe/config/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StatusDetailPage extends StatefulWidget {
  final Map<String, dynamic> statusData;
  final bool isMyStatus;

  const StatusDetailPage({
    super.key,
    required this.statusData,
    this.isMyStatus = false,
  });

  @override
  State<StatusDetailPage> createState() => _StatusDetailPageState();
}

class _StatusDetailPageState extends State<StatusDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLiked = false;

  // Dummy viewers data - ideally fetched from backend or passed via statusData
  final List<Map<String, dynamic>> _viewers = [
    {'name': 'Alex', 'time': DateTime.now().subtract(const Duration(minutes: 5)), 'liked': true},
    {'name': 'Budi', 'time': DateTime.now().subtract(const Duration(minutes: 15)), 'liked': false},
    {'name': 'Charlie', 'time': DateTime.now().subtract(const Duration(minutes: 30)), 'liked': false},
  ];

  @override
  void initState() {
    super.initState();
    
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

  Color _parseColor(String? colorHex) {
    if (colorHex == null || !colorHex.startsWith('#')) return AppColors.blue_500;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xff')));
    } catch (e) {
      return AppColors.blue_500;
    }
  }

  String _getTimeString(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.statusData;
    final user = status['user'] ?? {};
    final type = status['type'] ?? 'IMAGE';
    final mediaUrl = status['mediaUrl'];
    final content = status['content'];
    final bgColorHex = status['backgroundColor'];
    final caption = status['caption'];
    
    final theme = Theme.of(context);
    final statusColor = _parseColor(bgColorHex);

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 10) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Status Content
            Positioned.fill(
              child: type == 'TEXT'
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    color: statusColor,
                    alignment: Alignment.center,
                    child: Text(
                      content ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : mediaUrl != null
                  ? CachedNetworkImage(
                      imageUrl: mediaUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
                    )
                  : Container(color: Colors.grey[900]),
            ),

            // Top Gradient for Header Visibility
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
            ),

            // Progress Bar & Header
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: LinearProgressIndicator(
                      value: _controller.value,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white24,
                          backgroundImage: user['avatarUrl'] != null 
                            ? NetworkImage(user['avatarUrl']) as ImageProvider
                            : null,
                          child: user['avatarUrl'] == null 
                            ? Text(
                                (user['name'] ?? "?")[0],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              )
                            : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'] ?? "Unknown",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              status['createdAt'] ?? "Just now",
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Caption (Only for Media Status)
            if (type != 'TEXT' && caption != null && caption.toString().isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 100),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  child: Text(
                    caption,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
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
                final status = widget.statusData;
                final statusColor = _parseColor(status['backgroundColor']);
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: statusColor.withValues(alpha: 0.1),
                    child: Text(v['name'][0], style: TextStyle(color: statusColor)),
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
