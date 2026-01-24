import 'package:fe/config/app_color.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:fe/core/widgets/custom_text_field.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure1 = true;
  bool _isObscure2 = true;

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
    if (!_validatePassword()) {
      Fluttertoast.showToast(
        msg: "password_req_min8".tr(), // Fallback or generic message
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    if (_passController.text != _confirmController.text) {
      Fluttertoast.showToast(
        msg: "passwords_not_match".tr(),
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      Fluttertoast.showToast(
        msg: "password_reset_success".tr(),
        backgroundColor: AppColors.green_500,
        gravity: ToastGravity.TOP,
      );
      
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Fluttertoast.showToast(
        msg: "password_reset_error".tr(),
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("forgot_password_title".tr()),
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
            Text(
              "create_new_password_title".tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.blue_500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "new_password_instruction".tr(),
              style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _passController,
              label: "new_password_label".tr(),
              hint: "password_hint".tr(),
              obscureText: _isObscure1,
              prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.blue_500),
              suffixIcon: IconButton(
                icon: Icon(_isObscure1 ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _isObscure1 = !_isObscure1),
              ),
            ),
            const SizedBox(height: 12),
            _buildRequirementItem("password_req_min8".tr(), _min8Char),
            _buildRequirementItem("password_req_upper".tr(), _hasUpper),
            _buildRequirementItem("password_req_lower".tr(), _hasLower),
            _buildRequirementItem("password_req_digit".tr(), _hasDigit),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _confirmController,
              label: "confirm_password".tr(),
              hint: "password_hint".tr(),
              obscureText: _isObscure2,
              prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.blue_500),
              suffixIcon: IconButton(
                icon: Icon(_isObscure2 ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _isObscure2 = !_isObscure2),
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: "reset_password_btn".tr(),
              isLoading: _isLoading,
              onPressed: _resetPassword,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isValid) {
    final theme = Theme.of(context);
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
              color: isValid ? AppColors.green_600 : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
