import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/pages/home/chats_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fe/presentation/pages/home/more_page.dart';
import 'package:fe/presentation/pages/home/profile_page.dart';
import 'package:fe/presentation/pages/home/status_page.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

/// [DashboardPage] adalah kontainer utama untuk navigasi bawah (Bottom Navigation).
/// Halaman ini membungkus tab Chat, Status, Profil, dan Lainnya (More).
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Menyimpan indeks tab yang sedang dipilih
  int _selectedIndex = 0;
  final ValueNotifier<String> _searchQuery = ValueNotifier("");
  Timer? _debounce;

  @override
  void dispose() {
    _searchQuery.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery.value = value;
    });
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person_add_alt_1, color: AppColors.blue_500),
            title: Text("add_friend".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.addFriend);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts, color: AppColors.blue_500),
            title: Text("my_contacts".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.contacts);
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_add, color: AppColors.blue_500),
            title: Text("create_group_menu".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.createGroup);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Daftar halaman yang sesuai dengan tab di navigasi bawah
    final List<Widget> pages = [
      ValueListenableBuilder<String>(
        valueListenable: _searchQuery,
        builder: (context, query, _) => ChatsPage(searchQuery: query),
      ),
      const StatusPage(),
      const ProfilePage(),
      const MorePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: theme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "search_hint".tr(),
                    hintStyle: theme.inputDecorationTheme.hintStyle,
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.inputDecorationTheme.hintStyle?.color,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                _showAddMenu(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blue_500.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: AppColors.blue_500),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              'assets/logo/logo_dark.svg',
              width: 32,
              height: 32,
              colorFilter: const ColorFilter.mode(
                AppColors.blue_500,
                BlendMode.srcIn,
              ),
              placeholderBuilder: (_) => const Icon(
                Icons.chat_bubble_rounded,
                color: AppColors.blue_500,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
          showUnselectedLabels: true,
          type: theme.bottomNavigationBarTheme.type!,
          elevation: theme.bottomNavigationBarTheme.elevation,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble_outline),
              activeIcon: const Icon(Icons.chat_bubble),
              label: "chats".tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history_toggle_off),
              activeIcon: const Icon(Icons.history_toggle_off),
              label: "status".tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: "profile".tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.more_horiz),
              activeIcon: const Icon(Icons.more_horiz),
              label: "more".tr(),
            ),
          ],
        ),
      ),
    );
  }
}
