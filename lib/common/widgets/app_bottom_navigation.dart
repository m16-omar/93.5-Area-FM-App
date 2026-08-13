import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/app_colors.dart';
import '../../src/providers/radio_player_provider.dart';

class AppBottomNavigation extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static final List<_NavItem> _items = [
    const _NavItem(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home_rounded),
    const _NavItem(label: 'Shows', icon: Icons.radio_outlined, activeIcon: Icons.radio_rounded),
    const _NavItem(label: '', icon: Icons.headphones_rounded, activeIcon: Icons.headphones_rounded, isCenter: true),
    const _NavItem(label: 'Podcasts', icon: Icons.headphones_outlined, activeIcon: Icons.headphones_rounded),
    const _NavItem(label: 'Settings', icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark.withValues(alpha: 0.6) : AppColors.borderLight;
    final unselectedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final audioService = ref.watch(audioPlayerServiceProvider);
    final isPlaying = audioService.isPlaying;
    final isBuffering = audioService.isBuffering;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12,
            blurRadius: 16,
            offset: const Offset(0, -4),
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

                if (item.isCenter) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        audioService.togglePlayPause();
                        onTap(i);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -22,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: isPlaying ? 0.75 : 0.55),
                                    blurRadius: isPlaying ? 20 : 16,
                                    spreadRadius: isPlaying ? 4 : 3,
                                  ),
                                ],
                              ),
                              child: isBuffering
                                  ? const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Icon(
                                      isPlaying ? Icons.pause_rounded : Icons.headphones_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
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
                          color: isActive ? AppColors.primary : unselectedColor,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                            color: isActive ? AppColors.primary : unselectedColor,
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
    if (location.startsWith('/radio_player') || location.startsWith('/live')) { return 2; }
    if (location.startsWith('/podcasts') || location.startsWith('/videos')) { return 3; }
    if (location.startsWith('/settings') ||
        location.startsWith('/more') ||
        location.startsWith('/events') ||
        location.startsWith('/charts') ||
        location.startsWith('/presenters') ||
        location.startsWith('/notifications') ||
        location.startsWith('/blog')) { return 4; }
    return 0; // home
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isCenter;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.isCenter = false,
  });
}
