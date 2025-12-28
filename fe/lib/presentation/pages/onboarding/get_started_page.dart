import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "icon": "assets/getStarted/1.svg",
      "title": "Group Chatting",
      "desc": "Connect with multiple members in group chats.",
    },
    {
      "icon": "assets/getStarted/2.svg",
      "title": "Video and Voice Calls",
      "desc": "Instantly connect via video and voice calls.",
    },
    {
      "icon": "assets/getStarted/3.svg",
      "title": "Message Encryption",
      "desc": "Ensure privacy with encrypted messages.",
    },
    {
      "icon": "assets/getStarted/4.svg",
      "title": "Cross-Platform Compatibility",
      "desc": "Access chats on any device seamlessly.",
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ==== PAGE CONTENT ====
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(page["icon"]!, width: 200, height: 200),
                    const SizedBox(height: 24),
                    Text(
                      page["title"]!,
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: AppColors.blue_500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        page["desc"]!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppColors.blue_400,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ==== WAVE + BUTTON + INDICATOR ====
          SizedBox(
            height: 260,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // **Wave besar**
                Positioned(
                  bottom: -150,
                  child: ClipOval(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 2,
                      height: MediaQuery.of(context).size.width * 1.4,
                      color: AppColors.lightBlue_200,
                    ),
                  ),
                ),

                // **Wave kecil**
                Positioned(
                  bottom: -170,
                  child: ClipOval(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1.8,
                      height: MediaQuery.of(context).size.width * 1.2,
                      color: AppColors.lightBlue_100,
                    ),
                  ),
                ),

                // Tombol + indikator
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue_500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? "Continue"
                                : "Get Started",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.login,
                            ),
                            child: Text(
                              "Skip",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: AppColors.blue_400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Dots
                          Row(
                            children: List.generate(_pages.length, (i) {
                              bool active = i == _currentPage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: active ? 16 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: active
                                      ? AppColors.blue_500
                                      : AppColors.blue_200.withValues(
                                          alpha: 0.4,
                                        ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(width: 48),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
