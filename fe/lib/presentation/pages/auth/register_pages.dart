import 'dart:io';
import 'dart:ui';

import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:fe/presentation/pages/auth/widgets/register_steps.dart'; // New Import
import 'package:fe/core/network/service_locator.dart';
import 'package:fe/services/local_storage_service.dart';
import 'package:fe/presentation/pages/auth/verification_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

/// [RegisterPages] adalah halaman pendaftaran pengguna baru yang terdiri dari beberapa langkah (Multi-step).
/// Langkah 1: Input Email.
/// Langkah 2: Input Nama Lengkap & Foto Profil.
/// Langkah 3: Input Password & Konfirmasi.
class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  int _currentStep = 0;

  // Kontroller untuk menangkap input teks dari pengguna
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isObscure1 = true;
  bool _isObscure2 = true;
  File? _image;

  final picker = ImagePicker();

  /// Fungsi untuk memilih gambar profil, memberikan pilihan antara Kamera atau Galeri.
  Future<void> _pickImage() async {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            "pick_profile_picture".tr(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: AppColors.blue_500),
            title: Text("camera".tr()),
            onTap: () async {
              Navigator.pop(context);
              final pickedFile = await picker.pickImage(
                source: ImageSource.camera,
              );
              if (pickedFile != null)
                setState(() => _image = File(pickedFile.path));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppColors.blue_500),
            title: Text("gallery".tr()),
            onTap: () async {
              Navigator.pop(context);
              final pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null)
                setState(() => _image = File(pickedFile.path));
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _finishRegister();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  bool _isLoading = false;

  void _finishRegister() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: "passwords_not_match".tr(),
        backgroundColor: Colors.red,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ServiceLocator.authDataSource.register(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        "#000000",
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "register_success".tr(),
          backgroundColor: AppColors.green_500,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );
        
        if (!mounted) return;
        // Langsung pindah ke Login sesuai permintaan user
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      }
    } catch (e) {
      debugPrint("Register Error: $e");
      String errorMsg = "Registration failed";
      
      if (e is DioException && e.response?.data != null) {
        final responseData = e.response?.data;
        if (responseData is Map) {
          errorMsg = responseData['message'] ?? responseData['error'] ?? errorMsg;
        } else if (responseData is String) {
          errorMsg = "register_error".tr();
        }
      } else if (e is DioException && e.type == DioExceptionType.connectionTimeout) {
        errorMsg = "timeout_error".tr();
      }

      Fluttertoast.showToast(
        msg: errorMsg,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Password Logic
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Wave Background Top
          Positioned(
            top: -size.height * 0.25,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                height: size.height * 0.45,
                decoration: const BoxDecoration(gradient: AppColors.primary),
              ),
            ),
          ),
          // Page Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _prevStep,
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "register".tr(),
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Animated Steps
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                      child: _buildStepContent(),
                    ),
                  ),
                  // Progress Indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            bool isActive = index == _currentStep;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 6,
                              width: isActive ? 24 : 8,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.blue_500
                                    : AppColors.blue_400,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "step_of".tr(args: [(_currentStep + 1).toString()]),
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Next Button
                  PrimaryButton(
                    text: _currentStep == 2 ? "finish".tr() : "next".tr(),
                    isLoading: _isLoading,
                    onPressed: _nextStep,
                    borderRadius: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return EmailStep(controller: _emailController);
      case 1:
        return NameStep(
          controller: _nameController,
          image: _image,
          onPickImage: _pickImage,
        );
      case 2:
        return PasswordStep(
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          isObscure1: _isObscure1,
          isObscure2: _isObscure2,
          onToggleObscure1: () => setState(() => _isObscure1 = !_isObscure1),
          onToggleObscure2: () => setState(() => _isObscure2 = !_isObscure2),
          onPasswordChanged: _checkPassword,
          min8Char: _min8Char,
          hasUpper: _hasUpper,
          hasLower: _hasLower,
          hasDigit: _hasDigit,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.7,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
