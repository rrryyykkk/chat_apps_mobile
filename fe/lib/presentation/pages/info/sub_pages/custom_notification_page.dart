import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class CustomNotificationPage extends StatefulWidget {
  const CustomNotificationPage({super.key});

  @override
  State<CustomNotificationPage> createState() => _CustomNotificationPageState();
}

class _CustomNotificationPageState extends State<CustomNotificationPage> {
  bool _useCustomNotif = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral_50,
      appBar: AppBar(
        title: const Text("Notifications"),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
           Container(
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(12),
             ),
             child: SwitchListTile(
               title: const Text("Use Custom Notifications"),
               value: _useCustomNotif,
               activeColor: AppColors.blue_500,
               onChanged: (val) {
                 setState(() => _useCustomNotif = val);
               },
             ),
           ),
           if (_useCustomNotif) ...[
             const SizedBox(height: 16),
              Container(
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(12),
               ),
               child: Column(
                 children: [
                    ListTile(
                      title: const Text("Message Sound"),
                      subtitle: const Text("Default (Note)"),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text("Vibration"),
                      subtitle: const Text("Default"),
                       onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text("Popup notification"),
                      subtitle: const Text("Not available"),
                       onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text("Light"),
                      subtitle: const Text("White"),
                      trailing: Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          shape: BoxShape.circle
                        ),
                      ),
                       onTap: () {},
                    ),
                 ],
               ),
             ),
           ]
        ],
      ),
    );
  }
}
