import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../controllers/settings_controller.dart';
import '../../providers/radio_player_provider.dart';
import '../../routes/route_names.dart';
import '../../services/share_service.dart';
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
    final playerService = ref.watch(audioPlayerServiceProvider);
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
                          onTap: () => _showEqualizerSheet(context),
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.access_time_rounded,
                          iconBgColor: AppColors.primary,
                          title: 'Sleep Timer',
                          subtitle: playerService.hasActiveSleepTimer
                              ? 'Active (${(playerService.sleepTimerSecondsRemaining! / 60).ceil()}m remaining)'
                              : 'Set timer to stop playback',
                          onTap: () => _showSleepTimerSheet(context),
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.directions_car_rounded,
                          iconBgColor: const Color(0xFF0B6B82),
                          title: 'Car Mode',
                          subtitle: 'Optimized experience for driving',
                          onTap: () => context.push(RouteNames.carMode),
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.info_outline_rounded,
                          iconBgColor: AppColors.primary,
                          title: 'About AREA 93.5 FM',
                          subtitle: 'Learn more about us',
                          onTap: () => _showAboutDialog(context),
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.share_rounded,
                          iconBgColor: const Color(0xFF0B6B82),
                          title: 'Share the App',
                          subtitle: 'Tell your friends about AREA FM',
                          onTap: () => _shareApp(context),
                        ),
                        _TileDivider(isDark: isDark),
                        _SettingTileItem(
                          isDark: isDark,
                          icon: Icons.logout_rounded,
                          iconBgColor: const Color(0xFFFF3B30),
                          title: 'Log Out',
                          titleColor: const Color(0xFFFF3B30),
                          subtitle: 'Sign out of your account',
                          onTap: () => _confirmLogout(context),
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

  void _showEqualizerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Consumer(
        builder: (modalCtx, ref, child) {
          final playerService = ref.watch(audioPlayerServiceProvider);
          final isDark = Theme.of(modalCtx).brightness == Brightness.dark;
          final presets = ['Flat', 'Bass Boost', 'Pop', 'Rock', 'Vocal', 'Jazz'];

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF071216) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(
                color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                        onPressed: () => Navigator.of(modalCtx, rootNavigator: true).pop(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B6B82).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.tune_rounded, color: Color(0xFF0B6B82), size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Audio Equalizer',
                              style: GoogleFonts.poppins(
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Customize audio frequencies',
                              style: GoogleFonts.inter(
                                color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: playerService.eqEnabled,
                      activeTrackColor: const Color(0xFF0B6B82),
                      onChanged: (val) => playerService.toggleEqEnabled(val),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'PRESETS',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: presets.length,
                    separatorBuilder: (c, i) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final preset = presets[i];
                      final isSelected = playerService.eqPreset == preset;
                      return ChoiceChip(
                        label: Text(preset),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0B6B82),
                        backgroundColor: isDark ? const Color(0xFF0B1B22) : const Color(0xFFF1F5F9),
                        labelStyle: GoogleFonts.inter(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        onSelected: (val) {
                          if (val) playerService.setEqPreset(preset);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'FREQUENCY BANDS',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                ...playerService.eqBands.entries.map((entry) {
                  final band = entry.key;
                  final gain = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 54,
                          child: Text(
                            band,
                            style: GoogleFonts.inter(
                              color: isDark ? Colors.white.withValues(alpha: 0.87) : AppColors.textPrimaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: playerService.eqEnabled
                                  ? const Color(0xFF0B6B82)
                                  : Colors.grey,
                              inactiveTrackColor: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0),
                              thumbColor: playerService.eqEnabled
                                  ? const Color(0xFF0B6B82)
                                  : Colors.grey,
                              trackHeight: 6,
                            ),
                            child: Slider(
                              value: gain,
                              min: -12.0,
                              max: 12.0,
                              onChanged: playerService.eqEnabled
                                  ? (val) => playerService.setEqBand(band, val)
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${gain >= 0 ? "+" : ""}${gain.toStringAsFixed(0)} dB',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSleepTimerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Consumer(
        builder: (modalCtx, ref, child) {
          final playerService = ref.watch(audioPlayerServiceProvider);
          final isDark = Theme.of(modalCtx).brightness == Brightness.dark;
          final options = [15, 30, 45, 60, 90, 120];

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF071216) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(
                color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 22),
                        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                        onPressed: () => Navigator.of(modalCtx, rootNavigator: true).pop(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sleep Timer',
                          style: GoogleFonts.poppins(
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Automatically stop audio playback',
                          style: GoogleFonts.inter(
                            color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (playerService.hasActiveSleepTimer) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Timer Running',
                              style: GoogleFonts.inter(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${(playerService.sleepTimerSecondsRemaining! / 60).floor()}m ${(playerService.sleepTimerSecondsRemaining! % 60)}s remaining',
                              style: GoogleFonts.poppins(
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            playerService.cancelSleepTimer();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sleep timer cancelled')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF3B30),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Turn Off'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  'SET TIMER FOR',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.3,
                  children: options.map((mins) {
                    return InkWell(
                      onTap: () {
                        playerService.startSleepTimer(mins);
                        Navigator.of(modalCtx, rootNavigator: true).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sleep timer set for $mins minutes')),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0B1B22) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$mins mins',
                            style: GoogleFonts.inter(
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF071216) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0)),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            Image.asset(
              AppAssets.logo,
              height: 52,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.oceanBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '93.5 AREA FM',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0B6B82).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'One Voice, Every Area',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0B6B82),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '93.5 AREA FM is Nigeria\'s premier hit radio station bringing live radio, podcasts, exciting shows, latest news, and non-stop entertainment.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Frequency',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '93.5 MHz (Lagos)',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'App Version',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'v1.2.0 (Build 108)',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final url = Uri.parse('https://areafm.ng');
                      if (await canLaunchUrl(url)) await launchUrl(url);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: isDark ? const Color(0xFF14303D) : const Color(0xFFCBD5E1)),
                    ),
                    child: Text(
                      'Website',
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      context.push(RouteNames.team);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B6B82),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Our Team',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _shareApp(BuildContext context) {
    ShareService.shareContent(
      'Tune in live to 93.5 AREA FM - One Voice, Every Area! Download our mobile app now: https://areafm.ng/app',
      subject: '93.5 AREA FM App',
    );
  }

  void _confirmLogout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF071216) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0)),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded, color: Color(0xFFFF3B30), size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  'Log Out',
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 22),
              color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to log out of 93.5 AREA FM? You will need to sign in again to access personalized settings.',
          style: GoogleFonts.inter(
            color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go(RouteNames.login);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Log Out',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
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
            Color(0xFF085264),
            Color(0xFF0B6B82),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF085264).withValues(alpha: 0.4),
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
                      const Color(0xFF085264),
                      const Color(0xFF085264).withValues(alpha: 0.75),
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
