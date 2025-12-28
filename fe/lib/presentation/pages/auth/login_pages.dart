import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/presentation/pages/auth/register_pages.dart';
import 'package:fe/presentation/pages/auth/verification_page.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

/// [LoginPages] adalah halaman utama untuk autentikasi masuk pengguna.
/// Berisi input untuk Email dan Password, serta navigasi ke Registrasi atau Lupa Password.
class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  // Kontroller teks untuk input pengguna
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obsecurePassword = true;
  bool _rememberMe = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obsecurePassword = !_obsecurePassword;
    });
  }

  bool _isLoading = false;

  void login() {
    setState(() => _isLoading = true);

    // Simulate network request
    // No delay for FE only

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Login Success!"),
        backgroundColor: AppColors.green_500,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VerificationPage()),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPages()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // wave background top
          Positioned(
            top: -size.height * 0.25,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                height: size.height * 0.5,
                color: AppColors.lightBlue_600,
              ),
            ),
          ),
          // page Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Login",
                      style: theme.textTheme.headlineMedium!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                // email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter Your Email",
                    labelStyle: theme.textTheme.bodyMedium!.copyWith(
                      color: AppColors.neutral_400,
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.blue_500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // password filed
                TextField(
                  controller: _passwordController,
                  obscureText: _obsecurePassword,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter Your Password",
                    labelStyle: theme.textTheme.bodyMedium!.copyWith(
                      color: AppColors.neutral_400,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                      color: AppColors.blue_500,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obsecurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.neutral_500,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Remember Me & Forget Password
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (v) =>
                          setState(() => _rememberMe = v ?? false),
                      activeColor: AppColors.blue_500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(
                      "Remember Me",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: Text(
                    "Forget Password",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: AppColors.blue_500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // tombol loginya
                PrimaryButton(
                  text: "Login",
                  isLoading: _isLoading,
                  onPressed: login,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                    TextButton(
                      onPressed: _goToRegister,
                      child: Text(
                        "Register",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppColors.blue_500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// clipper untuk Wave
class TopWaveClipper extends CustomClipper<Path> {
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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
