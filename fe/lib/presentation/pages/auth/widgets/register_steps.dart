import 'dart:io';
import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailStep extends StatelessWidget {
  final TextEditingController controller;

  const EmailStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      key: const ValueKey(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Your Email",
            style: theme.textTheme.headlineSmall!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "We’ll send a confirmation link to verify your account.",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 60),
          TextField(
            controller: controller,
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
      ),
    );
  }
}

class NameStep extends StatelessWidget {
  final TextEditingController controller;
  final File? image;
  final VoidCallback onPickImage;

  const NameStep({
    super.key,
    required this.controller,
    required this.image,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      key: const ValueKey(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Who are you?",
            style: theme.textTheme.headlineLarge!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                backgroundImage: image != null ? FileImage(image!) : null,
                child: image == null
                    ? SvgPicture.asset(
                        'assets/avatar/avatarUser.svg',
                        width: 60,
                        height: 60,
                      )
                    : null,
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onPickImage,
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
            controller: controller,
            decoration: InputDecoration(
              labelText: "Full Name",
              hintText: "Enter your name",
              prefixIcon: const Icon(
                Icons.person_outlined,
                color: AppColors.neutral_700,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordStep extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isObscure1;
  final bool isObscure2;
  final VoidCallback onToggleObscure1;
  final VoidCallback onToggleObscure2;
  final ValueChanged<String> onPasswordChanged;
  final bool min8Char;
  final bool hasUpper;
  final bool hasLower;
  final bool hasDigit;

  const PasswordStep({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isObscure1,
    required this.isObscure2,
    required this.onToggleObscure1,
    required this.onToggleObscure2,
    required this.onPasswordChanged,
    required this.min8Char,
    required this.hasUpper,
    required this.hasLower,
    required this.hasDigit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      key: const ValueKey(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Set Password",
            style: theme.textTheme.headlineLarge!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: passwordController,
            onChanged: onPasswordChanged,
            obscureText: isObscure1,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(
                Icons.lock_outlined,
                color: AppColors.blue_500,
              ),
              suffixIcon: IconButton(
                onPressed: onToggleObscure1,
                icon: Icon(
                  isObscure1 ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.neutral_500,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          PasswordRequirementItem(text: "Min. 8 characters", isValid: min8Char),
          PasswordRequirementItem(text: "Uppercase Letter (A-Z)", isValid: hasUpper),
          PasswordRequirementItem(text: "Lowercase Letter (a-z)", isValid: hasLower),
          PasswordRequirementItem(text: "Digit (0-9)", isValid: hasDigit),

          const SizedBox(height: 24),
          TextField(
            controller: confirmPasswordController,
            obscureText: isObscure2,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              prefixIcon: const Icon(
                Icons.lock_outlined,
                color: AppColors.blue_500,
              ),
              suffixIcon: IconButton(
                onPressed: onToggleObscure2,
                icon: Icon(
                  isObscure2 ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.neutral_500,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordRequirementItem extends StatelessWidget {
  final String text;
  final bool isValid;

  const PasswordRequirementItem({
    super.key,
    required this.text,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
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
              color: isValid ? AppColors.green_600 : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
