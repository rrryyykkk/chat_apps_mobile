import 'package:fe/config/app_color.dart';
import 'package:fe/data/local/models/local_user.dart';
import 'package:fe/data/models/chat_model.dart';
import 'package:fe/data/repositories/contact_repository.dart';
import 'package:fe/data/repositories/chat_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fe/injection.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my_contacts_title".tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addFriend),
          )
        ],
      ),
      body: StreamBuilder<List<LocalUser>>(
        stream: locator<ContactRepository>().listenContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
          }
          
          final contacts = snapshot.data ?? [];
          
          if (contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                   const SizedBox(height: 16),
                   Text("no_contacts_yet".tr()),
                   TextButton(
                     onPressed: () => Navigator.pushNamed(context, AppRoutes.addFriend),
                     child: Text("add_friend".tr()),
                   )
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: contacts.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                leading: CircleAvatar(
                   backgroundColor: AppColors.blue_500,
                   backgroundImage: contact.avatarUrl != null ? NetworkImage(contact.avatarUrl!) : null,
                   child: contact.avatarUrl == null ? Text(contact.name.isNotEmpty ? contact.name[0] : "?") : null,
                ),
                title: Text(contact.alias != null && contact.alias!.isNotEmpty ? contact.alias! : contact.name),
                subtitle: Text(contact.email),
                onTap: () async {
                  // Show loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    // Create or get existing 1-on-1 chat with this contact
                    final response = await locator<ChatRepository>().createOrGetDirectChat(contact.userId);
                    
                    if (!context.mounted) return;
                    Navigator.pop(context); // Close loading
                    
                    if (response != null) {
                      // Navigate to chat with the actual chat from backend
                      Navigator.pushNamed(
                        context,
                        AppRoutes.singleChat,
                        arguments: response,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to create chat")),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context); // Close loading
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
