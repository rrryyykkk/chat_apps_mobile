import 'package:fe/config/app_color.dart';
import 'package:fe/services/local_storage_service.dart';
import 'package:fe/data/repositories/status_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fe/injection.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  late Future<List<dynamic>> _statusesFuture;
  late Future<bool> _hideStatusFuture;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _statusesFuture = locator<StatusRepository>().getStatuses();
    _hideStatusFuture = LocalStorageService.getHideStatusUpdates();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await LocalStorageService.getUserId();
    if (mounted) setState(() => _currentUserId = id);
  }

  Future<void> _refreshStatuses() async {
    setState(() {
      _statusesFuture = locator<StatusRepository>().getStatuses();
      _hideStatusFuture = LocalStorageService.getHideStatusUpdates();
    });
    await _loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshStatuses,
        child: Column(
          children: [
            // My Status Section
            FutureBuilder<List<dynamic>>(
              future: _statusesFuture,
              builder: (context, snapshot) {
                final statuses = snapshot.data ?? [];
                // Defensive check for userId
                final myStatus = statuses.firstWhere(
                  (s) => s['user'] != null && s['user']['id'].toString() == _currentUserId.toString(), 
                  orElse: () => null
                );

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    onTap: () {
                      if (myStatus != null) {
                        Navigator.pushNamed(
                          context, 
                          AppRoutes.statusDetail,
                          arguments: {
                            'statusData': myStatus,
                            'isMyStatus': true,
                          },
                        );
                      } else {
                         Navigator.pushNamed(context, AppRoutes.createMediaStatus).then((_) => _refreshStatuses());
                      }
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
                        if (myStatus == null)
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
                      "my_status".tr(),
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(myStatus != null ? "tap_to_view_status".tr() : "tap_to_add_status".tr()),
                  ),
                );
              }
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "recent_updates".tr(),
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: FutureBuilder<bool>(
                future: _hideStatusFuture,
                builder: (context, hideSnapshot) {
                  final isHidden = hideSnapshot.data ?? false;
                  
                  if (isHidden) {
                    return Center(child: Text("status_updates_hidden".tr()));
                  }

                  return FutureBuilder<List<dynamic>>(
                    future: _statusesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final allStatuses = snapshot.data ?? [];
                      final othersStatuses = allStatuses.where(
                        (s) => s['user'] != null && s['user']['id'].toString() != _currentUserId.toString()
                      ).toList();

                      if (othersStatuses.isEmpty) {
                        return Center(child: Text("no_status_updates".tr()));
                      }

                      return ListView.builder(
                        itemCount: othersStatuses.length,
                        itemBuilder: (context, index) {
                          final status = othersStatuses[index];
                          return _buildStatusItem(context, theme, status);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: "text_status",
            onPressed: () => Navigator.pushNamed(context, AppRoutes.createTextStatus).then((_) => _refreshStatuses()),
            backgroundColor: theme.colorScheme.surface,
            child: Icon(Icons.edit, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "media_status",
            onPressed: () => Navigator.pushNamed(context, AppRoutes.createMediaStatus).then((_) => _refreshStatuses()),
            backgroundColor: AppColors.blue_500,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context, ThemeData theme, dynamic status) {
    final user = status['user'] ?? {};
    final name = user['name'] ?? "unknown_user".tr();
    final timeStr = status['createdAt'] ?? "just_now".tr();
    final avatar = user['avatarUrl'];
    final type = status['type'];
    final bgColorHex = status['backgroundColor'];

    Color itemColor = avatar != null ? Colors.transparent : AppColors.blue_500;
    if (type == 'TEXT' && bgColorHex != null) {
       try {
         itemColor = Color(int.parse(bgColorHex.replaceFirst('#', '0xff')));
       } catch (_) {}
    }

    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context, 
          AppRoutes.statusDetail,
          arguments: {
            'statusData': status,
            'isMyStatus': false,
          },
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.blue_500, width: 2),
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: itemColor.withValues(alpha: 0.2),
          backgroundImage: avatar != null ? NetworkImage(avatar) : null,
          child: avatar == null ? Text(
            name.isNotEmpty ? name[0] : "?",
            style: TextStyle(color: itemColor == Colors.transparent ? AppColors.blue_500 : itemColor, fontWeight: FontWeight.bold),
          ) : null,
        ),
      ),
      title: Text(
        name,
        style: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        timeStr,
        style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6)),
      ),
    );
  }
}
