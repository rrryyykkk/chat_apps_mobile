import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _pinEnabled = false;
  bool _faceIdEnabled = false;
  bool _fingerprintEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral_50,
      appBar: AppBar(
        title: const Text("Security"),
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
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("App PIN"),
                  subtitle: const Text("Require PIN when opening app"),
                  value: _pinEnabled,
                  activeColor: AppColors.blue_500,
                  onChanged: (val) => setState(() => _pinEnabled = val),
                  secondary: const Icon(Icons.lock, color: AppColors.blue_500),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text("Face Recognition"),
                  value: _faceIdEnabled,
                  activeColor: AppColors.blue_500,
                  onChanged: (val) => setState(() => _faceIdEnabled = val),
                   secondary: const Icon(Icons.face, color: AppColors.blue_500),
                ),
                 const Divider(height: 1),
                SwitchListTile(
                  title: const Text("Fingerprint"),
                  value: _fingerprintEnabled,
                  activeColor: AppColors.blue_500,
                  onChanged: (val) => setState(() => _fingerprintEnabled = val),
                   secondary: const Icon(Icons.fingerprint, color: AppColors.blue_500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Biometric authentication requires device support.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
