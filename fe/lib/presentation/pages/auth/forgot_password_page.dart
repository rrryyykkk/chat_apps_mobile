import 'package:fe/config/app_color.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';

/// [ForgotPasswordPage] adalah halaman pertama untuk proses pemulihan kata sandi.
/// Pengguna memasukkan email mereka untuk menerima kode verifikasi (OTP).
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Kontroller teks untuk input email pemulihan
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _sendVerificationCode() async {


    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to Verification Page with argument indicating reset flow
    // We will verify the code then go to ResetPasswordPage
    Navigator.pushNamed(
      context, 
      AppRoutes.verification, 
      arguments: {'nextRoute': AppRoutes.resetPassword, 'email': _emailController.text, 'isResetParams': true},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reset via Email",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.blue_500,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Enter the email associated with your account and we'll send an email with instructions to reset your password.",
              style: TextStyle(color: AppColors.neutral_500),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Address",
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.blue_500),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: "Send Instructions",
              isLoading: _isLoading,
              onPressed: _sendVerificationCode,
            ),
          ],
        ),
      ),
    );
  }
}
