import 'package:fe/config/app_color.dart';
import 'package:fe/data/local/models/local_user.dart';
import 'package:fe/data/repositories/contact_repository.dart';
import 'package:fe/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectMembersPage extends StatefulWidget {
  const SelectMembersPage({super.key});

  @override
  State<SelectMembersPage> createState() => _SelectMembersPageState();
}

class _SelectMembersPageState extends State<SelectMembersPage> {
  final Set<String> _selectedIds = {};
  final Set<LocalUser> _selectedUsers = {};

  void _toggleSelection(LocalUser user) {
    setState(() {
      if (_selectedIds.contains(user.userId)) {
        _selectedIds.remove(user.userId);
        _selectedUsers.removeWhere((u) => u.userId == user.userId);
      } else {
        _selectedIds.add(user.userId);
        _selectedUsers.add(user);
      }
    });
  }

  void _finish() {
    Navigator.pop(context, _selectedUsers.toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("select_members".tr()),
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<LocalUser>>(
              stream: locator<ContactRepository>().listenContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final contacts = snapshot.data ?? [];
                
                if (contacts.isEmpty) {
                  return Center(child: Text("no_contacts_yet".tr()));
                }

                return ListView.separated(
                  itemCount: contacts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = contacts[index];
                    final isSelected = _selectedIds.contains(user.userId);
                    return ListTile(
                      onTap: () => _toggleSelection(user),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.blue_500.withValues(alpha: 0.1),
                        backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                        child: user.avatarUrl == null ? Text(
                          user.name.isNotEmpty ? user.name[0] : "?",
                           style: const TextStyle(
                                color: AppColors.blue_500,
                                fontWeight: FontWeight.bold),
                        ) : null,
                      ),
                      title: Text(user.alias ?? user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user.email),
                      trailing: Checkbox(
                        value: isSelected,
                        activeColor: AppColors.blue_500,
                        onChanged: (val) => _toggleSelection(user),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    );
                  },
                );
              }
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                )
              ]
            ),
            child: Row(
              children: [
                 Expanded(
                   child: OutlinedButton(
                     onPressed: () => Navigator.pop(context),
                     style: OutlinedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       side: const BorderSide(color: AppColors.neutral_300),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     ),
                     child: const Text("Cancel", style: TextStyle(color: AppColors.neutral_900)),
                   ),
                 ),
                 const SizedBox(width: 16),
                  Expanded(
                   child: ElevatedButton(
                     onPressed: _finish,
                     style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                       backgroundColor: AppColors.blue_500,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     ),
                     child: Text("Add (${_selectedIds.length})", style: const TextStyle(color: Colors.white)),
                   ),
                 ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
