import 'package:fe/config/app_color.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:fe/core/widgets/custom_text_field.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/core/network/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _sendVerificationCode() async {
    if (_emailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "fill_email_error".tr(),
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final response = await ServiceLocator.authDataSource.apiClient.post(
        '/auth/forgot-password', 
        data: {'email': _emailController.text},
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "otp_sent_msg".tr(),
          backgroundColor: AppColors.green_500,
          gravity: ToastGravity.TOP,
        );
        
        Navigator.pushNamed(
          context, 
          AppRoutes.verification, 
          arguments: {
            'nextRoute': AppRoutes.resetPassword, 
            'email': _emailController.text, 
            'isResetParams': true
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Fluttertoast.showToast(
        msg: "otp_send_error".tr(),
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
              "reset_via_email".tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.blue_500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "forgot_password_instruction".tr(),
              style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _emailController,
              label: "email".tr(),
              hint: "email_hint".tr(),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.blue_500),
            ),
            const SizedBox(height: 48),
            PrimaryButton(
              text: "send_instructions_btn".tr(),
              isLoading: _isLoading,
              onPressed: _sendVerificationCode,
            ),
          ],
        ),
      ),
    );
  }
}
