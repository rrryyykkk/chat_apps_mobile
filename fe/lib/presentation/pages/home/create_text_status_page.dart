import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class CreateTextStatusPage extends StatefulWidget {
  const CreateTextStatusPage({super.key});

  @override
  State<CreateTextStatusPage> createState() => _CreateTextStatusPageState();
}

class _CreateTextStatusPageState extends State<CreateTextStatusPage> {
  final _controller = TextEditingController();
  int _colorIndex = 0;
  final List<Color> _backgroundColors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColors[_colorIndex],
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLines: null,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: "Type a status",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _colorIndex = (_colorIndex + 1) % _backgroundColors.length;
                          });
                        },
                        icon: const Icon(Icons.palette, color: Colors.white, size: 28),
                      ),
                      IconButton(
                        onPressed: () {}, // Text style toggle
                        icon: const Icon(Icons.text_fields, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Status posted!")),
                      );
                    }
                  },
                  backgroundColor: AppColors.blue_500,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
