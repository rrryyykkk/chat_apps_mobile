import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/core/widgets/custom_text_field.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _nameController = TextEditingController();
  List<User> _selectedMembers = [];
  bool _isLoading = false;

  void _openSelectMembers() async {
    final result = await Navigator.pushNamed(context, AppRoutes.selectMembers);
    if (result != null && result is List<User>) {
      setState(() {
         // Merge logic sederhana untuk menghindari duplikat
         final currentIds = _selectedMembers.map((e) => e.id).toSet();
         for(var user in result) {
            if(!currentIds.contains(user.id)) {
              _selectedMembers.add(user);
            }
         }
      });
    }
  }

  void _removeMember(User user) {
     setState(() {
       _selectedMembers.removeWhere((element) => element.id == user.id);
     });
  }

  void _createGroup() async {
    if (_nameController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Group Name is required")),
      );
      return;
    }
    if (_selectedMembers.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add at least 1 member")),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300)); // Simulasi
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pop(context); // Balik ke Chats Page
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Group Created!"),
          backgroundColor: AppColors.green_500,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Group"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _nameController,
              label: "Group Name",
              hint: "Enter group name",
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Members (${_selectedMembers.length})",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _openSelectMembers,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text("Add Member"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _selectedMembers.isEmpty
                  ? Center(
                      child: Text(
                        "No members added",
                        style: TextStyle(color: AppColors.neutral_400),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _selectedMembers.length,
                      separatorBuilder: (_,__) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final user = _selectedMembers[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                             backgroundColor: user.color?.withValues(alpha: 0.2) ?? AppColors.neutral_100,
                             child: Text(user.name[0], style: TextStyle(color: user.color ?? Colors.black, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(user.email),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removeMember(user),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: "Create Group",
              onPressed: _createGroup,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
     );
  }
}
