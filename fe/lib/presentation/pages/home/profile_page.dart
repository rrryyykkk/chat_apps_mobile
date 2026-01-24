import 'package:fe/config/app_color.dart';
import 'package:fe/core/widgets/custom_text_field.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:fe/core/widgets/custom_image.dart';
import 'package:fe/services/local_storage_service.dart';
import 'package:fe/core/network/service_locator.dart';
import 'package:fe/data/datasources/media_remote_datasource.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fe/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

/// [ProfilePage] menampilkan informasi detail profil pengguna.
/// Memungkinkan pengguna untuk melihat data pribadi, mengedit foto profil, dan mengubah informasi akun.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Data pengguna riil
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await LocalStorageService.getUserData();
    setState(() {
      _userData = data;
      _nameController.text = data?['name'] ?? "";
      _isLoading = false;
    });
  }

  /// Menyalin teks ke clipboard dan menampilkan SnackBar
  void _copyData(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("copy_clipboard".tr()), duration: const Duration(seconds: 1)),
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
            Text("edit_profile_picture".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(Icons.image, "gallery".tr(), Colors.purple, () => _pickImage(ImageSource.gallery)),
                _buildImageOption(Icons.camera_alt, "camera".tr(), Colors.blue, () => _pickImage(ImageSource.camera)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Close bottom sheet
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() => _isLoading = true);
        
        // 1. Upload to Cloudinary
        final response = await locator<MediaRemoteDataSource>().uploadFile(image.path);
        
        if (response.statusCode == 200) {
          final imageUrl = response.data['data']['url'];
          
          // 2. Update Profile with new URL
          await _updateProfileWithImage(imageUrl);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "error_picking_image".tr());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfileWithImage(String url) async {
    final response = await ServiceLocator.authDataSource.apiClient.put(
      '/auth/profile',
      queryParameters: {'id': _userData?['id']},
      data: {
        'name': _userData?['name'],
        'avatarUrl': url,
      },
    );

    if (response.statusCode == 200) {
      final updatedData = response.data['data'];
      await LocalStorageService.saveUserData(updatedData);
      _loadUserData();
      Fluttertoast.showToast(msg: "profile_updated".tr());
    }
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
                      Text("edit_profile".tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      
                      // Fields Form
                      CustomTextField(controller: _nameController, label: "profile_name".tr()),
                      const SizedBox(height: 32),
                      
                      PrimaryButton(
                        text: "save_changes".tr(), 
                        onPressed: _updateProfile,
                      ),
                       const SizedBox(height: 40), // Bottom padding
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

  Future<void> _updateProfile() async {
    try {
      final response = await ServiceLocator.authDataSource.apiClient.put(
        '/auth/profile',
        queryParameters: {'id': _userData?['id']},
        data: {
          'name': _nameController.text,
          'avatarUrl': _userData?['avatarUrl'] ?? "",
        },
      );

      if (response.statusCode == 200) {
        final updatedData = response.data['data'];
        await LocalStorageService.saveUserData(updatedData);
        _loadUserData();
        if (mounted) {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "profile_updated".tr(),
            backgroundColor: AppColors.green_500,
            gravity: ToastGravity.TOP,
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "error_update_profile".tr(),
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
    }
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
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SingleChildScrollView(
         padding: const EdgeInsets.all(24),
         child: Column(
           children: [
             // Header: Foto Profil dengan Edit Icon
             Center(
               child: Stack(
                 children: [
                   CustomImage(
                     width: 120,
                     height: 120,
                     radius: 60,
                     url: _userData?['avatarUrl'] ?? "https://i.pravatar.cc/300", 
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
             _buildInfoItem("profile_name".tr(), _userData?['name'] ?? "-"),
             _buildInfoItem("profile_email".tr(), _userData?['email'] ?? "-"),

              const SizedBox(height: 48),
              
              // Tombol Edit Profile Full
              PrimaryButton(
                text: "edit_profile".tr(),
                onPressed: _showEditProfileSheet,
              ),
           ],
         ),
      ),
    );
  }
}
