import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/core/network/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

class VerificationPage extends StatefulWidget {
  final String? nextRoute;
  final String? email;
  final bool isResetParams;

  const VerificationPage({
    super.key, 
    this.nextRoute, 
    this.email,
    this.isResetParams = false,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (i) => FocusNode());

  int _timerSeconds = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _timerSeconds = 120);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTime() {
    int minutes = _timerSeconds ~/ 60;
    int seconds = _timerSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyCode();
      }
    } else if (value.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyCode() async {
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length < 6) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      Navigator.pop(context); // close dialog
      
      if (widget.nextRoute != null) {
        Navigator.pushReplacementNamed(context, widget.nextRoute!);
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Verification failed!", // Could use a key for this too
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
    }
  }

  void _resendOTP() async {
    if (_timerSeconds > 0) return;

    try {
      final response = await ServiceLocator.authDataSource.apiClient.post(
        '/auth/resend-otp',
        data: {'email': widget.email},
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "otp_resend_success".tr(),
          backgroundColor: AppColors.green_500,
          gravity: ToastGravity.TOP,
        );
        _startTimer();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "otp_resend_error".tr(),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              "verification".tr(),
              style: theme.textTheme.headlineMedium!.copyWith(
                    color: AppColors.blue_500,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.isResetParams 
                  ? "verification_instruction_reset".tr() 
                  : "verification_instruction_email".tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  ),
            ),
            if (widget.email != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.email!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 60,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) => _onDigitChanged(index, value),
                    style: theme.textTheme.headlineSmall!.copyWith(
                          color: AppColors.blue_600,
                          fontWeight: FontWeight.bold,
                        ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.blue_500, width: 2),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue_500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "verify_btn".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "didnt_receive_code".tr(),
                  style: theme.textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: _timerSeconds == 0 ? _resendOTP : null,
                  child: Text(
                    _timerSeconds > 0 
                      ? "resend_in".tr(args: [_formatTime()]) 
                      : "resend".tr(),
                    style: theme.textTheme.bodyMedium!.copyWith(
                          color: _timerSeconds > 0 ? AppColors.neutral_400 : AppColors.blue_500,
                          fontWeight: FontWeight.bold,
                          decoration: _timerSeconds == 0 ? TextDecoration.underline : null,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
