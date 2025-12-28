import 'package:fe/config/app_color.dart';
import 'package:fe/core/widgets/custom_text_field.dart';
import 'package:fe/core/widgets/primary_button.dart';
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
    if (_emailController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300)); // Simulasi
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Friend Added Successfully!"),
        backgroundColor: AppColors.green_500,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Friend"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neutral_900),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.neutral_900,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              label: "Friend's Name",
              hint: "Enter name",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              label: "Friend's Email",
              hint: "Enter email address",
              keyboardType: TextInputType.emailAddress,
            ),
            const Spacer(),
            PrimaryButton(
              text: "Add Friend",
              onPressed: _addFriend,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
