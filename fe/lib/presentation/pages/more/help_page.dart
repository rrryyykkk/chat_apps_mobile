import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral_50,
      appBar: AppBar(
        title: const Text("Help Center"),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("FAQ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          _buildFaqItem("How to delete messages?", "Long press a message and select delete."),
          _buildFaqItem("How to create a group?", "Go to dashboard, click (+), select Create Group."),
          _buildFaqItem("Is my chat secure?", "Yes, we prioritize your security."),
          const SizedBox(height: 24),
          const Text("Contact Support", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
             child: Row(
               children: const [
                 Icon(Icons.email, color: AppColors.blue_500),
                 SizedBox(width: 16),
                 Text("support@chatapp.com"),
               ],
             ),
          )
        ],
      ),
    );
  }

  Widget _buildFaqItem(String q, String a) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(q, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(a),
          )
        ],
      ),
    );
  }
}
