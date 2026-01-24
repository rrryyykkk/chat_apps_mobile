import 'dart:io';
import 'package:fe/config/app_color.dart';
import 'package:fe/data/datasources/media_remote_datasource.dart';
import 'package:fe/data/repositories/status_repository.dart';
import 'package:fe/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateMediaStatusPage extends StatefulWidget {
  const CreateMediaStatusPage({super.key});

  @override
  State<CreateMediaStatusPage> createState() => _CreateMediaStatusPageState();
}

class _CreateMediaStatusPageState extends State<CreateMediaStatusPage> {
  final _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Auto trigger picker on enter
    WidgetsBinding.instance.addPostFrameCallback((_) => _pickMedia());
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("pick_media".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(Icons.image, "gallery".tr(), Colors.purple, () => _handlePick(ImageSource.gallery)),
                _buildImageOption(Icons.camera_alt, "camera".tr(), Colors.blue, () => _handlePick(ImageSource.camera)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handlePick(ImageSource source) async {
    Navigator.pop(context);
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    } else if (_selectedImage == null) {
      if (mounted) Navigator.pop(context);
    }
  }

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

  void _postStatus() async {
    if (_selectedImage == null) return;
    
    setState(() => _isUploading = true);
    
    try {
      // 1. Upload to Cloudinary
      final mediaResponse = await locator<MediaRemoteDataSource>().uploadFile(_selectedImage!.path);
      
      if (mediaResponse.statusCode == 200) {
        final imageUrl = mediaResponse.data['url'] ?? mediaResponse.data['data']?['url'];
        
        // 2. Create Status in DB
        final success = await locator<StatusRepository>().createMediaStatus(
          imageUrl, 
          _captionController.text.trim()
        );
        
        if (mounted) {
          if (success) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("status_posted_success".tr())),
            );
          } else {
            throw Exception("Failed to save status");
          }
        }
      } else {
        throw Exception("Upload failed");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("error_uploading".tr()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Media Preview
          Center(
            child: _selectedImage != null 
              ? Image.file(_selectedImage!, fit: BoxFit.contain)
              : Container(
                  color: Colors.grey[900],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image, color: Colors.white24, size: 100),
                      const SizedBox(height: 16),
                      Text("media_preview".tr(), style: const TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                  const Spacer(),
                  if (_selectedImage != null)
                    IconButton(
                      onPressed: _pickMedia,
                      icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
                    ),
                ],
              ),
            ),
          ),

          if (_isUploading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text("posting_status".tr(), style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _captionController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "add_caption_hint".tr(),
                          hintStyle: const TextStyle(color: Colors.white60),
                          border: InputBorder.none,
                          filled: false,
                        ),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton(
                      onPressed: _isUploading ? null : _postStatus,
                      backgroundColor: AppColors.blue_500,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
