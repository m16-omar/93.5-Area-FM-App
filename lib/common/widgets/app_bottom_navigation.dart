import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static final List<_NavItem> _items = [
    _NavItem(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home_rounded),
    _NavItem(label: 'Shows', icon: Icons.radio_outlined, activeIcon: Icons.radio_rounded),
    _NavItem(label: 'Podcasts', icon: Icons.headphones_outlined, activeIcon: Icons.headphones_rounded),
    _NavItem(label: 'Videos', icon: Icons.play_circle_outline_rounded, activeIcon: Icons.play_circle_fill_rounded),
    _NavItem(label: 'More', icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(
            color: AppColors.borderDark.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: SizedBox(
            height: 54,
            child: Row(
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                final isActive = currentIndex == i;
                final isCenter = i == 2; // Podcasts = center elevated

                if (isCenter) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -18,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x66FF5500),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isActive ? item.activeIcon : item.icon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.label,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: isActive ? AppColors.primary : AppColors.textSecondaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive ? AppColors.primary : AppColors.textSecondaryDark,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                            color: isActive ? AppColors.primary : AppColors.textSecondaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  /// Resolve index from current route
  static int indexFromLocation(String location) {
    if (location.startsWith('/shows')) { return 1; }
    if (location.startsWith('/podcasts')) { return 2; }
    if (location.startsWith('/videos')) { return 3; }
    if (location.startsWith('/more') ||
        location.startsWith('/events') ||
        location.startsWith('/charts') ||
        location.startsWith('/presenters') ||
        location.startsWith('/notifications') ||
        location.startsWith('/settings')) { return 4; }
    return 0; // home
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
