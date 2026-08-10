import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../providers/settings_provider.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';
import 'widgets/dark_mode_tile.dart';
import 'widgets/settings_switch.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: const AreaFMAppBar(title: 'App Settings', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SettingsSectionWidget(
              title: 'Preferences',
              children: [
                const DarkModeTileWidget(),
                SettingsSwitchWidget(
                  icon: Icons.notifications_active_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Receive alerts when live shows start',
                  value: settings.pushNotifications,
                  onChanged: (val) => notifier.toggleNotifications(val),
                ),
                SettingsSwitchWidget(
                  icon: Icons.play_circle_outline_rounded,
                  title: 'Auto-play Stream',
                  subtitle: 'Start radio streaming when app launches',
                  value: settings.autoPlayStream,
                  onChanged: (val) => notifier.toggleAutoPlay(val),
                ),
              ],
            ),
            SettingsSectionWidget(
              title: 'Audio Quality',
              children: [
                SettingsTileWidget(
                  icon: Icons.high_quality_rounded,
                  title: 'Stream Quality',
                  subtitle: settings.audioQuality,
                  onTap: () {
                    notifier.setAudioQuality(
                      settings.audioQuality == 'HD (320kbps)' ? 'Standard (128kbps)' : 'HD (320kbps)',
                    );
                  },
                ),
              ],
            ),
            SettingsSectionWidget(
              title: 'Support & Station',
              children: [
                SettingsTileWidget(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () => context.push('/support'),
                ),
                SettingsTileWidget(
                  icon: Icons.info_outline_rounded,
                  title: 'About 93.5 Area FM',
                  onTap: () => context.push('/team'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
