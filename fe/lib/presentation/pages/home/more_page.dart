import 'package:fe/config/app_color.dart';
import 'package:fe/core/theme/theme_controller.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';

/// [MorePage] berisi pengaturan aplikasi seperti Dark Mode, Notifikasi, 
/// Bahasa, Keamanan, dan navigasi lainnya seperti Tentang Aplikasi.
class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  // State untuk menyimpan pilihan switch/toggle dari pengguna
  bool _darkMode = false;
  bool _muteNotifications = false;
  bool _hideChatHistory = false;
  
  // Dropdown
  String _selectedLanguage = "English";
  final List<String> _languages = ["English", "Indonesian", "Spanish", "French"];

  void _handleLogout() {
    // Navigate to Login Page and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(
      context, 
      AppRoutes.login, 
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Settings"),
                  _buildContainer(
                    children: [
                      _buildSwitchTile(
                        icon: Icons.dark_mode_outlined,
                        color: AppColors.neutral_800,
                        title: "Dark Mode",
                        value: _darkMode,
                        onChanged: (val) {
                          setState(() => _darkMode = val);
                          ThemeController.toggleTheme(val);
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.notifications_none_outlined,
                        color: AppColors.blue_500,
                        title: "Mute Notifications",
                        value: _muteNotifications,
                        onChanged: (val) => setState(() => _muteNotifications = val),
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.history,
                        color: AppColors.neutral_600,
                        title: "Hide Chat History",
                        value: _hideChatHistory,
                        onChanged: (val) => setState(() => _hideChatHistory = val),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader("Account & Security"),
                  _buildContainer(
                    children: [
                      _buildNavigationTile(
                        icon: Icons.security,
                        color: AppColors.green_500,
                        title: "Security",
                        onTap: () => Navigator.pushNamed(context, AppRoutes.security),
                      ),
                      _buildDivider(),
                      _buildLanguageTile(),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader("Support"),
                  _buildContainer(
                    children: [
                      _buildNavigationTile(
                        icon: Icons.help_outline,
                        color: AppColors.yellow_600,
                        title: "Help & Support",
                        onTap: () => Navigator.pushNamed(context, AppRoutes.help),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.description_outlined,
                        color: AppColors.neutral_500,
                        title: "Terms & Policies",
                        onTap: () => Navigator.pushNamed(context, AppRoutes.terms),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.info_outline,
                        color: AppColors.blue_400,
                        title: "About",
                        onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _handleLogout,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.red_500,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.red_500.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.light ? 0.05 : 0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color color,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      activeColor: AppColors.blue_500,
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.neutral_400,
      ),
    );
  }

  Widget _buildLanguageTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.blue_600.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.language, color: AppColors.blue_600, size: 20),
      ),
      title: Text(
        "Language",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.neutral_400),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLanguage = newValue;
              });
            }
          },
          items: _languages.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Theme.of(context).dividerTheme.color);
  }
}
