import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../controllers/settings_controller.dart';
import '../drawer/app_drawer.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool _downloadWifiOnly = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Graphic Banner with Studio Mic
            _SettingsHeaderBanner(size: size),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ACCOUNT SECTION
                    _SectionTitle(title: 'ACCOUNT', isDark: isDark),
                    _SettingsGroupCard(
                      isDark: isDark,
                      children: [
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.person_outline_rounded,
                          iconBgColor: const Color(0xFF0B6B82),
                          title: 'My Account',
                          subtitle: 'View and manage your profile',
                          onTap: () => context.push('/profile'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // PREFERENCES SECTION
                    _SectionTitle(title: 'PREFERENCES', isDark: isDark),
                    _SettingsGroupCard(
                      isDark: isDark,
                      children: [
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.notifications_outlined,
                          iconBgColor: AppColors.primary,
                          title: 'Notifications',
                          subtitle: 'Manage push notifications',
                          trailing: Switch.adaptive(
                            value: settings.pushNotifications,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) => notifier.toggleNotifications(val),
                          ),
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.volume_up_outlined,
                          iconBgColor: const Color(0xFF0B6B82),
                          title: 'Streaming Quality',
                          subtitle: 'Choose your streaming quality',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'High',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: () {
                            final newQuality = settings.audioQuality == 'HD (320kbps)'
                                ? 'Standard (128kbps)'
                                : 'HD (320kbps)';
                            notifier.setAudioQuality(newQuality);
                          },
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.download_rounded,
                          iconBgColor: AppColors.primary,
                          title: 'Download over Wi-Fi only',
                          subtitle: 'Save mobile data',
                          trailing: Switch.adaptive(
                            value: _downloadWifiOnly,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() {
                                _downloadWifiOnly = val;
                              });
                            },
                          ),
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.dark_mode_outlined,
                          iconBgColor: const Color(0xFF0B6B82),
                          title: 'Dark Mode',
                          subtitle: 'Use dark theme',
                          trailing: Switch.adaptive(
                            value: settings.isDarkMode,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) => notifier.toggleTheme(val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // APP SECTION
                    _SectionTitle(title: 'APP', isDark: isDark),
                    _SettingsGroupCard(
                      isDark: isDark,
                      children: [
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.tune_rounded,
                          iconBgColor: const Color(0xFF0B6B82),
                          title: 'Equalizer',
                          subtitle: 'Customize your audio experience',
                          onTap: () {},
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.access_time_rounded,
                          iconBgColor: AppColors.primary,
                          title: 'Sleep Timer',
                          subtitle: 'Set timer to stop playback',
                          onTap: () {},
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.directions_car_rounded,
                          iconBgColor: const Color(0xFF0B6B82),
                          title: 'Car Mode',
                          subtitle: 'Optimized experience for driving',
                          onTap: () {},
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.info_outline_rounded,
                          iconBgColor: AppColors.primary,
                          title: 'About AREA 93.5 FM',
                          subtitle: 'Learn more about us',
                          onTap: () => context.push('/team'),
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.share_rounded,
                          iconBgColor: const Color(0xFF0B6B82),
                          title: 'Share the App',
                          subtitle: 'Tell your friends about AREA FM',
                          onTap: () {},
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.logout_rounded,
                          iconBgColor: const Color(0xFFFF3B30),
                          title: 'Log Out',
                          titleColor: const Color(0xFFFF3B30),
                          subtitle: 'Sign out of your account',
                          onTap: () => context.go('/login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _SettingsHeaderBanner extends StatelessWidget {
  final Size size;
  const _SettingsHeaderBanner({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      height: 145,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF001F54),
            Color(0xFF003882),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF001F54).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Right Studio Microphone image with horizontal fade mask
            Positioned(
              right: 0,
              top: -10,
              bottom: -10,
              width: size.width * 0.55,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.transparent, Colors.white],
                    stops: [0.0, 0.35],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  AppAssets.studioMicOnly,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
            ),
            // Smooth Left Gradient for crisp text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF001F54),
                      const Color(0xFF001F54).withValues(alpha: 0.75),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.48, 0.88],
                  ),
                ),
              ),
            ),
            // Settings Title & Subtitle Column
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Settings',
                    style: GoogleFonts.outfit(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Manage your preferences and app settings.',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12.5,
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
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsGroupCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const _SettingsGroupCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C1728) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF162742) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  final bool isDark;
  const _TileDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 62,
      color: isDark ? const Color(0xFF162742) : const Color(0xFFF1F5F9),
    );
  }
}

class _SettingTileItem extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final Color? titleColor;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTileItem({
    required this.isDark,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    this.titleColor,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Circular Colored Icon Container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            // Title + Subtitle Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: titleColor ?? (isDark ? Colors.white : AppColors.textPrimaryLight),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            // Trailing Widget or Default Chevron
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
