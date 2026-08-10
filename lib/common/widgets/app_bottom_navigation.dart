import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../const/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  final StatefulNavigationShell? navigationShell;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNavigation({
    super.key,
    this.navigationShell,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      currentIndex: navigationShell != null ? navigationShell!.currentIndex : currentIndex,
      onTap: (index) {
        if (navigationShell != null) {
          navigationShell!.goBranch(index);
        } else if (onTap != null) {
          onTap!(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.radio_outlined),
          activeIcon: Icon(Icons.radio_rounded),
          label: 'Live',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mic_none_outlined),
          activeIcon: Icon(Icons.mic_rounded),
          label: 'Shows',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.podcasts_outlined),
          activeIcon: Icon(Icons.podcasts_rounded),
          label: 'Podcasts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          activeIcon: Icon(Icons.article_rounded),
          label: 'News',
        ),
      ],
    );
  }
}
