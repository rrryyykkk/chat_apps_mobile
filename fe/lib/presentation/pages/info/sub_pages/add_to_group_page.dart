import 'package:fe/config/app_color.dart';
import 'package:fe/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class AddToGroupPage extends StatefulWidget {
  const AddToGroupPage({super.key});

  @override
  State<AddToGroupPage> createState() => _AddToGroupPageState();
}

class _AddToGroupPageState extends State<AddToGroupPage> {
  // Dummy Groups
  final List<String> _groups = [
    "Dumb Ways to Die",
    "Family Group",
    "Work Team",
    "Futsal Sunday",
  ];
  String? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add to Group"),
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
              itemCount: _groups.length,
              separatorBuilder: (_,__) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final group = _groups[index];
                return RadioListTile<String>(
                  title: Text(group, style: const TextStyle(fontWeight: FontWeight.bold)),
                  value: group,
                  groupValue: _selectedGroup,
                  activeColor: AppColors.blue_500,
                  onChanged: (val) {
                    setState(() => _selectedGroup = val);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: PrimaryButton(
              text: "Add to Selected Group",
              onPressed: _selectedGroup == null ? null : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Added to $_selectedGroup"), backgroundColor: AppColors.green_500),
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
