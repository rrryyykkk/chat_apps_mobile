import 'package:fe/config/app_color.dart';
import 'package:fe/core/widgets/custom_text_field.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:fe/core/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [ProfilePage] menampilkan informasi detail profil pengguna.
/// Memungkinkan pengguna untuk melihat data pribadi, mengedit foto profil, dan mengubah informasi akun.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Data dummy pengguna untuk keperluan tampilan (UI Only)
  final Map<String, String> _userData = {
    "Name": "Muhammad Rizky",
    "Email": "rizky@example.com",
    "Gender": "Male",
    "Birth Date": "12 October 1999"
  };

  /// Menyalin teks ke clipboard dan menampilkan SnackBar
  void _copyData(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to Clipboard"), duration: Duration(seconds: 1)),
    );
  }

  /// Menampilkan opsi edit foto (Gallery/Link) dalam BottomSheet
  void _showEditImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Edit Profile Picture", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(Icons.image, "Gallery (Internal)", Colors.purple, () => Navigator.pop(ctx)),
                _buildImageOption(Icons.link, "Link (External)", Colors.blue, () => Navigator.pop(ctx)),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Helper untuk membangun item opsi gambar
  Widget _buildImageOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Menampilkan form edit profil dalam BottomSheet full-screen
  void _showEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Full screen capabilities
      backgroundColor: Colors.transparent, // Transparan agar bisa custom BG
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          final theme = Theme.of(context);
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar area
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                     color: theme.colorScheme.surface, 
                     borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(color: theme.dividerTheme.color, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                     padding: const EdgeInsets.all(24),
                    children: [
                      const Text("Edit Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      
                      // Fields Form
                      CustomTextField(controller: TextEditingController(text: _userData['Name']), label: "Name"),
                      const SizedBox(height: 16),
                      CustomTextField(controller: TextEditingController(text: _userData['Email']), label: "Email"),
                      const SizedBox(height: 16),
                       CustomTextField(controller: TextEditingController(text: _userData['Gender']), label: "Gender"),
                      const SizedBox(height: 16),
                       CustomTextField(controller: TextEditingController(text: _userData['Birth Date']), label: "Birth Date"),
                      const SizedBox(height: 32),
                      
                      PrimaryButton(
                        text: "Save Changes", 
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
                        }
                      ),
                       const SizedBox(height: 32), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  /// Membangun item informasi user (Key: Value) dengan fitur copy
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: () => _copyData(value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label / Icon area (bisa diganti icon jika mau, tapi text label lebih jelas)
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.neutral_500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Value
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Copy Icon hint
            const Icon(Icons.copy, size: 16, color: AppColors.neutral_300),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
         padding: const EdgeInsets.all(24),
         child: Column(
           children: [
             // Header: Foto Profil dengan Edit Icon
             Center(
               child: Stack(
                 children: [
                   const CustomImage(
                     width: 120,
                     height: 120,
                     radius: 60,
                     url: "https://i.pravatar.cc/300", // Dummy URL
                   ),
                   Positioned(
                     top: 0,
                     right: 0,
                     child: GestureDetector(
                       onTap: _showEditImageOptions,
                       child: Container(
                         padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.blue_500,
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(BorderSide(color: theme.scaffoldBackgroundColor, width: 2)),
                          ),
                         child: const Icon(Icons.edit, size: 16, color: Colors.white),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 32),

             // List Data User
             ..._userData.entries.map((e) => _buildInfoItem(e.key, e.value)),

              const SizedBox(height: 48),
              
              // Tombol Edit Profile Full
              PrimaryButton(
                text: "Edit Profile",
                onPressed: _showEditProfileSheet,
              ),
           ],
         ),
      ),
    );
  }
}
