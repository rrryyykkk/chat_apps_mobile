import 'package:fe/config/app_color.dart';
import 'package:fe/presentation/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
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
      "title": "onboarding_1_title",
      "desc": "onboarding_1_desc",
    },
    {
      "icon": "assets/getStarted/2.svg",
      "title": "onboarding_2_title",
      "desc": "onboarding_2_desc",
    },
    {
      "icon": "assets/getStarted/3.svg",
      "title": "onboarding_3_title",
      "desc": "onboarding_3_desc",
    },
    {
      "icon": "assets/getStarted/4.svg",
      "title": "onboarding_4_title",
      "desc": "onboarding_4_desc",
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
      backgroundColor: theme.scaffoldBackgroundColor, // Use theme background
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
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        SvgPicture.asset(page["icon"]!, width: 220, height: 220),
                        const SizedBox(height: 30),
                        Text(
                          page["title"]!.tr(),
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: AppColors.blue_500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            page["desc"]!.tr(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
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
                Positioned(
                  bottom: -150,
                  child: ClipOval(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 2,
                      height: MediaQuery.of(context).size.width * 1.4,
                      color: AppColors.lightBlue_200.withValues(alpha: 0.3),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -170,
                  child: ClipOval(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1.8,
                      height: MediaQuery.of(context).size.width * 1.2,
                      color: AppColors.lightBlue_100.withValues(alpha: 0.3),
                    ),
                  ),
                ),

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
                                ? "continue_btn".tr()
                                : "get_started_btn".tr(),
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
                              "skip_btn".tr(),
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
