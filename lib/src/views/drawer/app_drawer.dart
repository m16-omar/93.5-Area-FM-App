import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../providers/auth_provider.dart';
import '../../routes/route_names.dart';
import '../../controllers/settings_controller.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  static const _navItems = [
    _DrawerNavItem(icon: Icons.home_rounded, label: 'Home', route: RouteNames.home, isGo: true),
    _DrawerNavItem(icon: Icons.mic_rounded, label: 'Shows', route: RouteNames.shows, isGo: true),
    _DrawerNavItem(icon: Icons.headphones_rounded, label: 'Podcasts', route: RouteNames.podcasts, isGo: true),
    _DrawerNavItem(icon: Icons.play_circle_fill_rounded, label: 'Videos', route: RouteNames.videos),
    _DrawerNavItem(icon: Icons.bar_chart_rounded, label: 'Charts', route: RouteNames.charts),
    _DrawerNavItem(icon: Icons.local_activity_outlined, label: 'Events', route: RouteNames.events),
    _DrawerNavItem(icon: Icons.people_outline_rounded, label: 'Team Members', route: RouteNames.presenters),
    _DrawerNavItem(icon: Icons.newspaper_rounded, label: 'News & Blog', route: RouteNames.blog),
    _DrawerNavItem(icon: Icons.notifications_outlined, label: 'Notifications', route: RouteNames.notifications, badge: 3),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isDark = ref.watch(themeModeProvider);

    final bg = isDark ? AppColors.surfaceDark : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111827);
    final textSecondary = isDark ? AppColors.textSecondaryDark : const Color(0xFF6B7280);
    final dividerColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);

    return Drawer(
      backgroundColor: bg,
      child: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Station Logo Image
                  Image.asset(
                    AppAssets.logo,
                    height: 42,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '93.5 ',
                            style: GoogleFonts.bebasNeue(fontSize: 18, color: textPrimary, letterSpacing: 2),
                          ),
                          TextSpan(
                            text: 'AREA ',
                            style: GoogleFonts.bebasNeue(fontSize: 26, color: AppColors.primary, letterSpacing: 2),
                          ),
                          TextSpan(
                            text: 'FM',
                            style: GoogleFonts.bebasNeue(fontSize: 26, color: textPrimary, letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User Profile Row
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark2 : const Color(0xFFE5E7EB),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person_rounded, color: isDark ? Colors.white70 : const Color(0xFF9CA3AF), size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Big P',
                              style: GoogleFonts.poppins(
                                color: textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              user?.email ?? 'bigp@areafm.ng',
                              style: GoogleFonts.inter(
                                color: textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 22),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, color: dividerColor),
                ],
              ),
            ),
          ),
          // Nav items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ..._navItems.map((item) => _DrawerTile(item: item, isDark: isDark)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(height: 24, color: dividerColor),
                ),
                // Settings & Support
                _DrawerTile(
                  isDark: isDark,
                  item: const _DrawerNavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    route: RouteNames.settings,
                  ),
                ),
                _DrawerTile(
                  isDark: isDark,
                  item: const _DrawerNavItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    route: RouteNames.support,
                  ),
                ),
                // Dark mode toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.dark_mode_outlined, size: 22, color: isDark ? Colors.white70 : const Color(0xFF374151)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Dark Mode',
                          style: GoogleFonts.inter(
                            color: textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Switch(
                        value: isDark,
                        onChanged: (v) => ref.read(settingsNotifierProvider.notifier).toggleTheme(v),
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: isDark ? AppColors.surfaceDark2 : const Color(0xFFE5E7EB),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(height: 24, color: dividerColor),
                ),
                // Logout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(currentUserProvider.notifier).logout();
                      context.go(RouteNames.login);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.logout_rounded, color: AppColors.primary, size: 22),
                        const SizedBox(width: 14),
                        Text(
                          'Log Out',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final _DrawerNavItem item;
  final bool isDark;
  const _DrawerTile({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isActive = GoRouterState.of(context).uri.path == item.route;
    final iconColor = isActive
        ? AppColors.primary
        : (isDark ? Colors.white70 : const Color(0xFF374151));
    final textColor = isActive
        ? AppColors.primary
        : (isDark ? Colors.white : const Color(0xFF374151));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          item.icon,
          size: 22,
          color: iconColor,
        ),
        title: Text(
          item.label,
          style: GoogleFonts.inter(
            color: textColor,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: item.badge != null && item.badge! > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${item.badge}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        onTap: () {
          Navigator.pop(context);
          if (item.isGo) {
            context.go(item.route);
          } else {
            context.push(item.route);
          }
        },
      ),
    );
  }
}

class _DrawerNavItem {
  final IconData icon;
  final String label;
  final String route;
  final bool isGo;
  final int? badge;
  const _DrawerNavItem({
    required this.icon,
    required this.label,
    required this.route,
    this.isGo = false,
    this.badge,
  });
}
