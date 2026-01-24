import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// [ChatInfoPage] menampilkan detail informasi chat (Single/Group).
/// Berisi opsi untuk media, notifikasi, keamanan, dan pengaturan lainnya.
class ChatInfoPage extends StatefulWidget {
  final Chat chat;
  const ChatInfoPage({super.key, required this.chat});

  @override
  State<ChatInfoPage> createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  // Toggle states (State untuk switch di UI)
  bool _isMuted = false;
  bool _isProtected = false; // Chat Lock / Security
  bool _isChatHidden = false; // Archive or Hide
  // ignore: unused_field
  bool _isStatusHidden = false; // Mute Status (bisa digunakan nanti)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral_50,
      body: CustomScrollView(
        slivers: [
          // 1. Custom Navbar / Appbar dengan Foto Profil Besar
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 300, // Tinggi header saat expanded
            pinned: true, // Appbar tetap terlihat saat scroll
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neutral_900),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60), // Spacer untuk status bar
                  // Foto Profil
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.blue_100,
                    backgroundImage: widget.chat.icon != null
                        ? NetworkImage(widget.chat.icon!)
                        : null,
                    child: widget.chat.icon == null
                        ? Icon(
                            widget.chat.isGroup ? Icons.group : Icons.person,
                            size: 50,
                            color: AppColors.blue_500,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Nama Chat
                  Text(
                    widget.chat.name,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Detail Tambahan (Member count atau Email)
                  Text(
                    widget.chat.isGroup 
                      ? "members_count".tr(args: [widget.chat.participants.length.toString()]) 
                      : "user@email.com", // Placeholder info
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.neutral_500,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Isi Halaman (List Menu)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Section 1: Media, Links, Docs
                  _buildSectionContainer(
                    children: [
                      _buildActionItem(
                        icon: Icons.image,
                        color: Colors.purple,
                        label: "media_links_docs".tr(),
                        trailingBadge: "12", // Contoh count
                        onTap: () {
                           Navigator.pushNamed(context, AppRoutes.mediaLinks);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section 2: Toggles (Mute, Protect, etc)
                  _buildSectionContainer(
                    children: [
                      _buildToggleItem(
                        label: "mute_notifications".tr(),
                        value: _isMuted,
                        onChanged: (val) => setState(() => _isMuted = val),
                      ),
                      const Divider(height: 1, color: AppColors.neutral_100),
                      _buildToggleItem(
                        label: "chat_lock".tr(), // Menggunakan _isProtected
                        value: _isProtected,
                        onChanged: (val) => setState(() => _isProtected = val),
                      ),
                       const Divider(height: 1, color: AppColors.neutral_100),
                      _buildToggleItem(
                        label: "hide_chat".tr(),
                        value: _isChatHidden,
                        onChanged: (val) => setState(() => _isChatHidden = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section 3: Customization & Utils
                  _buildSectionContainer(
                    children: [
                        _buildActionItem(
                        icon: Icons.notifications_active,
                        color: Colors.orange,
                        label: "custom_notifications".tr(),
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.customNotification);
                        },
                      ),
                      const Divider(height: 1, color: AppColors.neutral_100),
                       _buildActionItem(
                        icon: Icons.color_lens,
                        color: Colors.pink,
                        label: "wallpaper_sound".tr(),
                        onTap: () {
                           Navigator.pushNamed(context, AppRoutes.wallpaperSound);
                        },
                      ),
                      // Tampilkan 'Add to Group' hanya jika ini single chat, atau logika lain sesuai kebutuhan
                       const Divider(height: 1, color: AppColors.neutral_100),
                        _buildActionItem(
                        icon: Icons.group_add,
                        color: Colors.blue,
                        label: "add_to_group".tr(),
                        onTap: () {
                           Navigator.pushNamed(context, AppRoutes.addToGroup);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section 4: Critical Actions (Block/Report)
                  _buildSectionContainer(
                    children: [
                       _buildActionItem(
                        icon: Icons.flag,
                        color: Colors.red,
                        label: "report_user".tr(args: [widget.chat.name]),
                        textColor: Colors.red,
                        onTap: () {
                          // Implement report logic
                        },
                      ),
                      const Divider(height: 1, color: AppColors.neutral_100),
                       _buildActionItem(
                        icon: Icons.block,
                        color: Colors.red,
                        label: "block_user".tr(args: [widget.chat.name]),
                         textColor: Colors.red,
                        onTap: () {
                          // Implement block logic
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Membungkus list item dengan style Card rounded putih
  Widget _buildSectionContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  /// Membuat item menu yang bisa diklik (Navigation/Action)
  Widget _buildActionItem({
    required IconData icon,
    required Color color,
    required String label,
    VoidCallback? onTap,
    String? trailingBadge,
    Color? textColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.neutral_900,
        ),
      ),
      trailing: trailingBadge != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trailingBadge,
                  style: const TextStyle(
                    color: AppColors.neutral_500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.neutral_400),
              ],
            )
          : const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.neutral_400),
    );
  }

  /// Membuat item menu dengan Switch/Toggle
  Widget _buildToggleItem({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.neutral_900),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.blue_500,
      ),
    );
  }
}
