import 'package:flutter/material.dart';

class GlobalErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const GlobalErrorWidget({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
              const SizedBox(height: 16),
              const Text(
                "Waduh!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ada yang salah nih. Kami sedang memperbaikinya.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              if (errorDetails.exceptionAsString().contains(
                "RenderFlex",
              )) // Sembunyikan detail teknis kecuali spesifik
                Text(
                  "Terdeteksi Error Layout (RenderFlex).",
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
