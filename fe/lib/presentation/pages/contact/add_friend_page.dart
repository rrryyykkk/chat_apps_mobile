import 'package:fe/config/app_color.dart';
import 'package:fe/core/widgets/custom_text_field.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:dio/dio.dart';
import 'package:fe/data/repositories/contact_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fe/injection.dart';
import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  void _addFriend() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("fill_email_error".tr())),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = locator<ContactRepository>();
      // Alias is optional, use name controller as alias if provided, or empty
      await repo.addContact(_emailController.text, _nameController.text);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("friend_added_success".tr()),
          backgroundColor: AppColors.green_500,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      String errorMsg = "friend_added_error".tr();
      
      // If server provides a human-readable "message", we can use it
      // but otherwise we stay with our localized generic error
      if (e is DioException && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map) {
          final serverMsg = data['message'] ?? data['error'];
          // Only show serverMsg if it doesn't look like a log (short and simple)
          if (serverMsg != null && serverMsg.toString().length < 50) {
            errorMsg = serverMsg.toString();
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("add_friend_title".tr()),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _nameController,
              label: "friend_alias_label".tr(),
              hint: "friend_alias_hint".tr(),
            ),
            const SizedBox(height: 40),
            CustomTextField(
              controller: _emailController,
              label: "friend_email_label".tr(),
              hint: "friend_email_hint".tr(),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 70),
            PrimaryButton(
              text: "add_friend_title".tr(),
              onPressed: _addFriend,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
