import 'package:fe/config/app_color.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';

/// [ResetPasswordPage] adalah halaman akhir proses pemulihan akun untuk mengatur kata sandi baru.
/// Memiliki fitur pengecekan kekuatan kata sandi dan konfirmasi kata sandi.
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // Kontroller teks untuk input kata sandi baru dan konfirmasinya
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure1 = true;
  bool _isObscure2 = true;

  // Password Logic from Register (Reused)
  bool _min8Char = false;
  bool _hasUpper = false;
  bool _hasLower = false;
  bool _hasDigit = false;

  void _checkPassword(String val) {
    setState(() {
      _min8Char = val.length >= 8;
      _hasUpper = val.contains(RegExp(r'[A-Z]'));
      _hasLower = val.contains(RegExp(r'[a-z]'));
      _hasDigit = val.contains(RegExp(r'[0-9]'));
    });
  }

  bool _validatePassword() {
    return _min8Char && _hasUpper && _hasLower && _hasDigit;
  }

  void _resetPassword() async {


    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password successfully reset! Please Login.")),
    );
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reset Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create New Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.blue_500,
              ),
            ),
             const SizedBox(height: 12),
            const Text(
              "Your new password must be different from previous used passwords.",
              style: TextStyle(color: AppColors.neutral_500),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _passController,
              onChanged: _checkPassword,
              obscureText: _isObscure1,
              decoration: InputDecoration(
                labelText: "New Password",
                prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.blue_500),
                suffixIcon: IconButton(
                  icon: Icon(_isObscure1 ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscure1 = !_isObscure1),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            _buildRequirementItem("Min. 8 characters", _min8Char),
            _buildRequirementItem("Uppercase Letter (A-Z)", _hasUpper),
            _buildRequirementItem("Lowercase Letter (a-z)", _hasLower),
            _buildRequirementItem("Digit (0-9)", _hasDigit),
            const SizedBox(height: 24),
            TextField(
              controller: _confirmController,
              obscureText: _isObscure2,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.blue_500),
                suffixIcon: IconButton(
                  icon: Icon(_isObscure2 ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscure2 = !_isObscure2),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: "Reset Password",
              isLoading: _isLoading,
              onPressed: _resetPassword,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.circle_outlined,
            color: isValid ? AppColors.green_500 : AppColors.neutral_400,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isValid ? AppColors.green_600 : AppColors.neutral_500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
