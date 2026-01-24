import 'package:fe/config/app_color.dart';
import 'package:fe/data/local/models/local_user.dart';
import 'package:fe/data/repositories/chat_repository.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:fe/core/widgets/custom_text_field.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:fe/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _nameController = TextEditingController();
  List<LocalUser> _selectedMembers = [];
  bool _isLoading = false;

  void _openSelectMembers() async {
    final result = await Navigator.pushNamed(context, AppRoutes.selectMembers);
    if (result != null && result is List<LocalUser>) {
      setState(() {
         final currentIds = _selectedMembers.map((e) => e.userId).toSet();
         for(var user in result) {
            if(!currentIds.contains(user.userId)) {
              _selectedMembers.add(user);
            }
         }
      });
    }
  }

  void _removeMember(LocalUser user) {
     setState(() {
       _selectedMembers.removeWhere((element) => element.userId == user.userId);
     });
  }

  void _createGroup() async {
    if (_nameController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("fill_fields_error".tr())),
      );
      return;
    }
    if (_selectedMembers.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("no_members_error".tr())),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final userIds = _selectedMembers.map((e) => e.userId).toList();
      await locator<ChatRepository>().createGroup(_nameController.text.trim(), userIds);
      
      if (!mounted) return;
      Navigator.pop(context); // Balik ke Chats Page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("group_created_success".tr()),
          backgroundColor: AppColors.green_500,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("group_created_error".tr()), backgroundColor: Colors.red),
        );
      }
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
        title: Text("create_group_title".tr()),
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
              label: "group_name_label".tr(),
              hint: "group_name_hint".tr(),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                   "${"members".tr()} (${_selectedMembers.length})",
                  style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _openSelectMembers,
                  icon: const Icon(Icons.add, size: 20),
                  label: Text("add_member".tr()),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_selectedMembers.isEmpty)
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Text(
                    "no_members_added".tr(),
                    style: const TextStyle(color: AppColors.neutral_400),
                  ),
                )
            else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedMembers.length,
                  separatorBuilder: (_,__) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = _selectedMembers[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                         backgroundColor: AppColors.blue_500.withValues(alpha: 0.1),
                         backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                         child: user.avatarUrl == null ? Text(
                           user.name.isNotEmpty ? user.name[0] : "?",
                           style: const TextStyle(color: AppColors.blue_500, fontWeight: FontWeight.bold)
                         ) : null,
                      ),
                      title: Text(user.alias ?? user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _removeMember(user),
                      ),
                    );
                  },
                ),
            const SizedBox(height: 60),
            PrimaryButton(
              text: "create_group_btn".tr(),
              onPressed: _createGroup,
              isLoading: _isLoading,
            ),
             const SizedBox(height: 50),
          ],
        ),
      ),
     );
  }
}
