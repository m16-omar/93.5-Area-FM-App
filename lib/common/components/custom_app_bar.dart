import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/app_colors.dart';
import '../../const/app_assets.dart';
import '../../src/controllers/notification_controller.dart';
import '../../src/routes/route_names.dart';

/// Centered logo app bar matching the designer spec.
/// Shows hamburger (drawer) on left, prominent brand logo in center,
/// and notification bell on right by default. Theme-aware for light/dark modes.
class AreaFMAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showBack;
  final bool showNotification;
  final bool showSearch;
  final String? title; // optional plain text title (e.g. "Presenter Profile")
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMenuTap;
  final int? notificationCount;
  final List<Widget>? actions;
  final Color? foregroundColor;

  const AreaFMAppBar({
    super.key,
    this.showBack = false,
    this.showNotification = true,
    this.showSearch = false,
    this.title,
    this.onNotificationTap,
    this.onSearchTap,
    this.onMenuTap,
    this.notificationCount,
    this.actions,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final iconColor = foregroundColor ?? defaultColor;
    final dynamicUnreadCount = ref.watch(unreadNotificationCountProvider);
    final count = notificationCount ?? dynamicUnreadCount;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        leading: showBack
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: iconColor, size: 22),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go(RouteNames.home);
                  }
                },
              )
            : IconButton(
                icon: Icon(Icons.menu, color: iconColor, size: 26),
                onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
              ),
        title: title != null
            ? Text(
                title!,
                style: GoogleFonts.poppins(
                  color: iconColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            : _AreaFMLogo(isDark: isDark),
        centerTitle: true,
        actions: actions ??
            [
              if (showSearch)
                IconButton(
                  icon: Icon(Icons.search_rounded, color: iconColor, size: 24),
                  onPressed: onSearchTap ?? () {},
                ),
              if (showNotification)
                _NotificationBell(
                  count: count,
                  iconColor: iconColor,
                  onTap: onNotificationTap ?? () => context.push(RouteNames.notifications),
                ),
              const SizedBox(width: 8),
            ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class _AreaFMLogo extends StatelessWidget {
  final bool isDark;
  const _AreaFMLogo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Image.asset(
        AppAssets.logo,
        height: 48,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
        final textColor = isDark ? Colors.white : AppColors.textPrimaryLight;
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '93.5\n',
                style: GoogleFonts.bebasNeue(fontSize: 14, color: textColor, height: 1.0),
              ),
              TextSpan(
                text: 'AREA ',
                style: GoogleFonts.bebasNeue(fontSize: 24, color: AppColors.primary),
              ),
              TextSpan(
                text: 'FM',
                style: GoogleFonts.bebasNeue(fontSize: 24, color: textColor),
              ),
            ],
          ),
        );
      },
    ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final int count;
  final Color iconColor;
  final VoidCallback? onTap;

  const _NotificationBell({required this.count, required this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.notifications_outlined, color: iconColor, size: 26),
          ),
          if (count > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
