import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.neutral_600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(32), // Fully rounded
            border: Border.all(
              color: isDark ? Colors.white12 : AppColors.neutral_200,
              width: 1.2,
            ),
            boxShadow: isDark ? [] : [
               BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: isDark ? Colors.white30 : AppColors.neutral_300),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), // Increased for rounded look
              prefixIcon: prefixIcon != null ? Padding(
                padding: const EdgeInsets.only(left: 8),
                child: prefixIcon,
              ) : null,
              suffixIcon: suffixIcon != null ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: suffixIcon,
              ) : null,
            ),
          ),
        ),
      ],
    );
  }
}
