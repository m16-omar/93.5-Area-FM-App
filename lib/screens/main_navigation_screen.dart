import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../widgets/persistent_mini_player.dart';
import 'home_screen.dart';
import 'live_radio_screen.dart';
import 'schedule_screen.dart';
import 'podcasts_screen.dart';
import 'news_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final ValueNotifier<bool> isDarkModeNotifier;

  const MainNavigationScreen({super.key, required this.isDarkModeNotifier});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const LiveRadioScreen(),
      const ScheduleScreen(),
      const PodcastsScreen(),
      const NewsScreen(),
      SettingsScreen(isDarkModeNotifier: widget.isDarkModeNotifier),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sticky Bottom Audio Mini-Player
          const PersistentMiniPlayer(),

          // Bottom Navigation Bar
          NavigationBar(
            selectedIndex: _currentIndex > 4 ? 4 : _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            indicatorColor: AppColors.primaryOrange.withOpacity(0.2),
            elevation: 8,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: AppColors.primaryOrange),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.radio_outlined),
                selectedIcon: Icon(Icons.radio, color: AppColors.primaryOrange),
                label: 'Live FM',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month, color: AppColors.primaryOrange),
                label: 'Schedule',
              ),
              NavigationDestination(
                icon: Icon(Icons.podcasts_outlined),
                selectedIcon: Icon(Icons.podcasts, color: AppColors.primaryOrange),
                label: 'Podcasts',
              ),
              NavigationDestination(
                icon: Icon(Icons.newspaper_outlined),
                selectedIcon: Icon(Icons.newspaper, color: AppColors.primaryOrange),
                label: 'News',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
