import 'package:fe/config/app_color.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:flutter/material.dart';

class SelectMembersPage extends StatefulWidget {
  const SelectMembersPage({super.key});

  @override
  State<SelectMembersPage> createState() => _SelectMembersPageState();
}

class _SelectMembersPageState extends State<SelectMembersPage> {
  // Dummy Contacts
  final List<User> _contacts = [
    User(id: "u2", name: "Ucup", email: "ucup@mail.com", color: Colors.orange),
    User(id: "u3", name: "Asep", email: "asep@mail.com", color: Colors.purple),
    User(id: "u4", name: "Budi", email: "budi@mail.com", color: Colors.green),
    User(id: "u5", name: "Siti", email: "siti@mail.com", color: Colors.pink),
  ];

  final Set<String> _selectedIds = {};

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _finish() {
    final selectedUsers =
        _contacts.where((u) => _selectedIds.contains(u.id)).toList();
    Navigator.pop(context, selectedUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Members"),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _contacts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = _contacts[index];
                final isSelected = _selectedIds.contains(user.id);
                return ListTile(
                  onTap: () => _toggleSelection(user.id),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: user.color?.withValues(alpha: 0.2) ?? AppColors.neutral_100,
                    child: Text(
                      user.name[0],
                       style: TextStyle(
                            color: user.color ?? AppColors.neutral_900,
                            fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  subtitle: Text(user.email),
                  trailing: Checkbox(
                    value: isSelected,
                    activeColor: AppColors.blue_500,
                    onChanged: (val) => _toggleSelection(user.id),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                );
              },
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
