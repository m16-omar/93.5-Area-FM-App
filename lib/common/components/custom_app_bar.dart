import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/app_colors.dart';
import '../../const/app_assets.dart';

/// Centered logo app bar matching the designer spec.
/// Shows hamburger (drawer) on left, prominent brand logo in center,
/// and notification bell on right by default.
class AreaFMAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final bool showNotification;
  final bool showSearch;
  final String? title; // optional plain text title (e.g. "Presenter Profile")
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;
  final int notificationCount;
  final List<Widget>? actions;

  const AreaFMAppBar({
    super.key,
    this.showBack = false,
    this.showNotification = true,
    this.showSearch = false,
    this.title,
    this.onNotificationTap,
    this.onMenuTap,
    this.notificationCount = 1,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                onPressed: () => Navigator.of(context).pop(),
              )
            : IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 26),
                onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
              ),
        title: title != null
            ? Text(
                title!,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            : _AreaFMLogo(),
        centerTitle: true,
        actions: actions ??
            [
              if (showSearch)
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 24),
                  onPressed: () {},
                ),
              if (showNotification)
                _NotificationBell(
                  count: notificationCount,
                  onTap: onNotificationTap,
                ),
              const SizedBox(width: 8),
            ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}

class _AreaFMLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      height: 64,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '93.5\n',
                style: GoogleFonts.bebasNeue(fontSize: 14, color: Colors.white, height: 1.0),
              ),
              TextSpan(
                text: 'AREA ',
                style: GoogleFonts.bebasNeue(fontSize: 24, color: AppColors.primary),
              ),
              TextSpan(
                text: 'FM',
                style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const _NotificationBell({required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
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
