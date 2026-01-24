import 'package:fe/config/app_color.dart';
import 'package:fe/core/theme/theme_controller.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/services/local_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';
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
  bool _hideStatusUpdates = false;
  
  // Dropdown
  String _selectedLanguage = "English";
  final List<String> _languages = [
    "English", 
    "Indonesian", 
    "Spanish", 
    "Chinese", 
    "Arabic", 
    "Malay"
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final results = await Future.wait([
      LocalStorageService.getMuteNotifications(),
      LocalStorageService.getHideChatHistory(),
      LocalStorageService.getHideStatusUpdates(),
    ]);

    final mute = results[0];
    final hideChat = results[1];
    final hideStatus = results[2];
    final darkMode = ThemeController.themeNotifier.value == ThemeMode.dark;
    
    // Determine selected language from context
    String langName = "English";
    final currentLocale = context.locale.languageCode;
    if (currentLocale == 'id') langName = "Indonesian";
    else if (currentLocale == 'es') langName = "Spanish";
    else if (currentLocale == 'zh') langName = "Chinese";
    else if (currentLocale == 'ar') langName = "Arabic";
    else if (currentLocale == 'ms') langName = "Malay";

    setState(() {
      _muteNotifications = mute;
      _hideChatHistory = hideChat;
      _hideStatusUpdates = hideStatus;
      _darkMode = darkMode;
      _selectedLanguage = langName;
    });
  }

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
                  _buildSectionHeader("settings_section".tr()),
                  _buildContainer(
                    children: [
                      _buildSwitchTile(
                        icon: Icons.dark_mode_outlined,
                        color: AppColors.neutral_800,
                        title: "dark_mode".tr(),
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
                        title: "mute_notifications".tr(),
                        value: _muteNotifications,
                        onChanged: (val) {
                          setState(() => _muteNotifications = val);
                          LocalStorageService.setMuteNotifications(val);
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.history,
                        color: AppColors.neutral_600,
                        title: "hide_chat_history".tr(),
                        value: _hideChatHistory,
                        onChanged: (val) {
                          setState(() => _hideChatHistory = val);
                          LocalStorageService.setHideChatHistory(val);
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.visibility_off_outlined,
                        color: AppColors.blue_500,
                        title: "hide_status_updates".tr(),
                        value: _hideStatusUpdates,
                        onChanged: (val) {
                          setState(() => _hideStatusUpdates = val);
                          LocalStorageService.setHideStatusUpdates(val);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader("account_security_section".tr()),
                  _buildContainer(
                    children: [
                      _buildNavigationTile(
                        icon: Icons.security,
                        color: AppColors.green_500,
                        title: "security".tr(),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.security),
                      ),
                      _buildDivider(),
                      _buildLanguageTile(),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader("support_section".tr()),
                  _buildContainer(
                    children: [
                      _buildNavigationTile(
                        icon: Icons.help_outline,
                        color: AppColors.yellow_600,
                        title: "help_support".tr(),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.help),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.description_outlined,
                        color: AppColors.neutral_500,
                        title: "terms_policies".tr(),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.terms),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.info_outline,
                        color: AppColors.blue_400,
                        title: "about".tr(),
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
                      child: Text(
                        "logout_btn".tr(),
                        style: const TextStyle(
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
        "language".tr(),
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
              if (newValue == "English") {
                context.setLocale(const Locale('en'));
              } else if (newValue == "Indonesian") {
                context.setLocale(const Locale('id'));
              } else if (newValue == "Spanish") {
                context.setLocale(const Locale('es'));
              } else if (newValue == "Chinese") {
                context.setLocale(const Locale('zh'));
              } else if (newValue == "Arabic") {
                context.setLocale(const Locale('ar'));
              } else if (newValue == "Malay") {
                context.setLocale(const Locale('ms'));
              }
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
