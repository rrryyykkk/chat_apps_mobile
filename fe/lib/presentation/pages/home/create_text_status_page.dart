import 'package:fe/config/app_color.dart';
import 'package:fe/data/repositories/status_repository.dart';
import 'package:fe/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreateTextStatusPage extends StatefulWidget {
  const CreateTextStatusPage({super.key});

  @override
  State<CreateTextStatusPage> createState() => _CreateTextStatusPageState();
}

class _CreateTextStatusPageState extends State<CreateTextStatusPage> {
  final _controller = TextEditingController();
  int _colorIndex = 0;
  bool _isPosting = false;

  final List<Color> _backgroundColors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];

  void _postStatus() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isPosting = true);
    
    final hexColor = '#${_backgroundColors[_colorIndex].value.toRadixString(16).substring(2)}';
    final success = await locator<StatusRepository>().createTextStatus(text, hexColor);
    
    if (mounted) {
      setState(() => _isPosting = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("status_posted_success".tr())),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("error_uploading".tr()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColors[_colorIndex],
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLines: null,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "type_status_hint".tr(),
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                  ),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isPosting)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          Align(
            alignment: Alignment.bottomRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: FloatingActionButton(
                  onPressed: _isPosting ? null : _postStatus,
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
