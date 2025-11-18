import 'dart:io';
import 'dart:ui';

import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  final _pagesController = PageController();
  int _currentStep = 0;

  // controllersnya
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  File? _image;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pagesController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishRegister();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pagesController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _finishRegister() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Register Complete')));
    Navigator.pushReplacementNamed(context, AppRoutes.home);
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
          // glassMorphism Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          // Page Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // top bar
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
                        "Register",
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // animated steps
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
                      child: PageView(
                        key: ValueKey(_currentStep),
                        controller: _pagesController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildEmailStep(theme),
                          _buildPasswordStep(theme),
                          _buildProfileStep(theme),
                        ],
                      ),
                    ),
                  ),
                  // proges indicator
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
                          "Step #${_currentStep + 1} of 3",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.blue_600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // next Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _currentStep == 2 ? "Finish" : "Next",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // step 1
  Widget _buildEmailStep(ThemeData theme) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Your Email",
          style: theme.textTheme.headlineSmall!.copyWith(
            color: AppColors.lightBlue_400,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "We’ll send a confirmation link to verify your account.",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.lightBlue_400,
          ),
        ),
        const SizedBox(height: 80),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email",
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.blue_500,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
  // step 2

  Widget _buildPasswordStep(ThemeData theme) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create your Password",
          style: theme.textTheme.headlineLarge!.copyWith(
            color: AppColors.blue_500,
          ),
        ),
        const SizedBox(height: 60),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: const Icon(
              Icons.lock_outlined,
              color: AppColors.blue_500,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _isObscure1 = !_isObscure1),
              icon: Icon(
                _isObscure1 ? Icons.visibility_off : Icons.visibility,
                color: AppColors.neutral_500,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            prefixIcon: const Icon(
              Icons.lock_outlined,
              color: AppColors.blue_500,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _isObscure2 = !_isObscure2),
              icon: Icon(
                _isObscure2 ? Icons.visibility_off : Icons.visibility,
                color: AppColors.neutral_500,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  // step 3
  Widget _buildProfileStep(ThemeData theme) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Profile Setup",
          style: theme.textTheme.headlineLarge!.copyWith(
            color: AppColors.blue_500,
          ),
        ),
        const SizedBox(height: 40),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.blue_100,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : const AssetImage('assets/avatar/avatarUser.svg')
                        as ImageProvider,
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.blue_500,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Full Name",
            prefixIcon: const Icon(
              Icons.person_outlined,
              color: AppColors.neutral_700,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
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
