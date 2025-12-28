import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class WallpaperSoundPage extends StatelessWidget {
  const WallpaperSoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral_50,
       appBar: AppBar(
        title: const Text("Wallpaper & Sound"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neutral_900),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.neutral_900,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Preview
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.blue_100, // Default preview
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage("https://picsum.photos/400/200"), // Dummy BG
                  fit: BoxFit.cover,
                  opacity: 0.5,
                )
              ),
              child: const Center(
                child: Text("Preview Chat Background", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            
            // Actions
            _buildOption(context, "Change Wallpaper", Icons.wallpaper),
            const SizedBox(height: 12),
            _buildOption(context, "Chat Bubble Colors", Icons.color_lens),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.blue_500),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mock feature: Open Picker")));
        },
      ),
    );
  }
}
