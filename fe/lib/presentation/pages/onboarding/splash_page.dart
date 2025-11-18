import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/pages/onboarding/get_started_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Pindah setelah animasi selesai
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const GetStartedPage()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              "assets/animation/logo_white.json",
              controller: _controller,
              width: 150,
              onLoaded: (composition) {
                _controller.duration = composition.duration;
                _controller.forward();
              },
            ),

            const SizedBox(height: 16),

            Text(
              "V1.0.0",
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: AppColors.blue_300),
            ),
          ],
        ),
      ),
    );
  }
}
