import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Terms of Service"),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("1. Acceptance of Terms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("By accessing or using this Chat Application, you agree to be bound by these Terms of Service. If you do not agree to all of these terms, do not use the application."),
            const SizedBox(height: 16),
            const Text("2. Privacy Policy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Your privacy is important to us. We collect minimal personal data such as your email and name to provide chat services. Your messages are stored securely and we do not sell your personal information to third parties."),
            const SizedBox(height: 16),
            const Text("3. User Conduct", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("You agree not to use the application for any unlawful purpose or to transmit any material that is harassing, defamatory, or otherwise objectionable. We reserve the right to terminate accounts that violate these guidelines."),
            const SizedBox(height: 16),
            const Text("4. Security", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("We implement industry-standard security measures to protect your data. However, no electronic transmission or storage is 100% secure. You are responsible for maintaining the confidentiality of your account password."),
            const SizedBox(height: 16),
            const Text("5. Changes to Terms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("We may update these terms from time to time. Your continued use of the application after such changes constitutes your acceptance of the new terms."),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "Last Updated: January 2026",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
