import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/route_names.dart';
import '../../../common/widgets/app_button.dart';
import 'widgets/onboarding_item.dart';
import 'widgets/page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = const [
    {
      'title': 'Live Radio Streaming',
      'description': 'Listen to 93.5 Area FM live anywhere in crystal clear HD quality.',
      'icon': Icons.radio,
    },
    {
      'title': 'Podcasts & Shows',
      'description': 'Catch up on missed shows, exclusive podcasts, and celebrity interviews.',
      'icon': Icons.podcasts,
    },
    {
      'title': 'Events & Music Charts',
      'description': 'Stay updated with upcoming urban music festivals and vote for top chart hits.',
      'icon': Icons.event,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go(RouteNames.home),
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) => OnboardingItemWidget(
                  title: _pages[index]['title'],
                  description: _pages[index]['description'],
                  icon: _pages[index]['icon'],
                ),
              ),
            ),
            PageIndicatorWidget(count: _pages.length, currentIndex: _currentIndex),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AppButton(
                title: _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: () {
                  if (_currentIndex < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.go(RouteNames.home);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
