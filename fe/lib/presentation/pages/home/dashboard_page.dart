import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/pages/home/chats_page.dart';
import 'package:fe/presentation/pages/home/more_page.dart';
import 'package:fe/presentation/pages/home/profile_page.dart';
import 'package:fe/presentation/pages/home/status_page.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  // Daftar halaman yang sesuai dengan tab di navigasi bawah
  final List<Widget> _pages = [
    const ChatsPage(),
    const StatusPage(),
    const ProfilePage(),
    const MorePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
            title: const Text("Add Friend"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.addFriend);
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_add, color: AppColors.blue_500),
            title: const Text("Create Group"),
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
                  decoration: InputDecoration(
                    hintText: "Search...",
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
              'assets/logo/logo_dark.svg', // Fixed missing logo_blue.svg
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
      body: IndexedStack(index: _selectedIndex, children: _pages),
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: "Chats",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_toggle_off),
              activeIcon: Icon(Icons.history_toggle_off),
              label: "Status",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              activeIcon: Icon(Icons.more_horiz),
              label: "More",
            ),
          ],
        ),
      ),
    );
  }
}
