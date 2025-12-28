import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// [StatusPage] menampilkan status/cerita (Snap) dari pengguna dan teman.
/// Terbagi menjadi bagian "My Status" dan "Recent Updates".
class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // My Status Section
          ListTile(
            onTap: () {
              Navigator.pushNamed(
                context, 
                AppRoutes.statusDetail,
                arguments: {
                  'userName': "My Status",
                  'userColor': AppColors.blue_500,
                  'isMyStatus': true,
                },
              );
            },
            contentPadding: EdgeInsets.zero,
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.blue_500.withValues(alpha: 0.1),
                  child: SvgPicture.asset(
                    'assets/avatar/avatarUser.svg',
                    width: 32,
                    height: 32,
                    placeholderBuilder: (_) => const Icon(Icons.person, color: AppColors.blue_500),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_circle,
                      color: AppColors.blue_500,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              "My Status",
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text("Tap to add status update"),
          ),
          const SizedBox(height: 24),
          
          // Recent Updates Section
          Text(
            "Recent Updates",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // Dummy List
          _buildStatusItem(context, theme, "Jane Cooper", "10 minutes ago", Colors.pink),
          _buildStatusItem(context, theme, "Floyd Miles", "36 minutes ago", Colors.orange),
          _buildStatusItem(context, theme, "Ronald Richards", "1 hour ago", Colors.purple),
          _buildStatusItem(context, theme, "Esther Howard", "Yesterday", Colors.blue),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: "text_status",
            onPressed: () => Navigator.pushNamed(context, AppRoutes.createTextStatus),
            backgroundColor: theme.colorScheme.surface,
            child: Icon(Icons.edit, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "media_status",
            onPressed: () => Navigator.pushNamed(context, AppRoutes.createMediaStatus),
            backgroundColor: AppColors.blue_500,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context, ThemeData theme, String name, String time, Color color) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context, 
          AppRoutes.statusDetail,
          arguments: {
            'userName': name,
            'userColor': color,
          },
        );
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.blue_500, width: 2),
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text(
            name[0],
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      title: Text(
        name,
        style: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        time,
        style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6)),
      ),
    );
  }
}
