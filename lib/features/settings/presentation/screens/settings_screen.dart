import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../../live_radio/presentation/providers/audio_player_provider.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return StorageService.isDarkMode();
  }

  Future<void> toggleTheme(bool isDark) async {
    state = isDark;
    await StorageService.setDarkMode(isDark);
  }
}

final themeModeProvider = NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final audioState = ref.watch(audioPlayerProvider);
    final audioNotifier = ref.read(audioPlayerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS & PREFERENCES'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text('APP THEME & AUDIO', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryOrange, fontSize: 12, letterSpacing: 1)),
          ),
          SwitchListTile(
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: AppColors.primaryOrange),
            title: const Text('Dark Theme'),
            subtitle: const Text('Sleek dark mode tailored for radio listening'),
            value: isDarkMode,
            onChanged: (val) async {
              await ref.read(themeModeProvider.notifier).toggleTheme(val);
            },
          ),
          ListTile(
            leading: const Icon(Icons.high_quality, color: AppColors.primaryBlue),
            title: const Text('Streaming Quality'),
            subtitle: Text('Current: ${audioState.quality}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              _showQualityPicker(context, audioNotifier, audioState.quality);
            },
          ),
          const ListTile(
            leading: Icon(Icons.timer_outlined, color: AppColors.primaryOrange),
            title: Text('Sleep Timer'),
            subtitle: Text('Off'),
          ),

          const Divider(height: 32),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text('STUDIO CONTACT', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryOrange, fontSize: 12, letterSpacing: 1)),
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Color(0xFF25D366)),
            title: const Text('WhatsApp Studio Hotline'),
            subtitle: const Text(AppConstants.whatsappNumber),
            onTap: () async {
              final url = Uri.parse('https://wa.me/${AppConstants.whatsappNumber}');
              if (await canLaunchUrl(url)) await launchUrl(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: AppColors.primaryBlue),
            title: const Text('Call Studio Direct'),
            subtitle: const Text(AppConstants.studioPhone),
            onTap: () async {
              final url = Uri.parse('tel:${AppConstants.studioPhone}');
              if (await canLaunchUrl(url)) await launchUrl(url);
            },
          ),

          const Divider(height: 32),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text('CACHE & STORAGE', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryOrange, fontSize: 12, letterSpacing: 1)),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined, color: Colors.redAccent),
            title: const Text('Clear Local Cache'),
            subtitle: const Text('Free up stored podcasts and news images'),
            onTap: () async {
              await StorageService.cacheBox.clear();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  static void _showQualityPicker(BuildContext context, AudioPlayerNotifier notifier, String currentQuality) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Streaming Quality', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.hd, color: AppColors.primaryOrange),
                title: const Text('High Definition (320 kbps)'),
                trailing: currentQuality.contains('HD') ? const Icon(Icons.check, color: AppColors.primaryOrange) : null,
                onTap: () {
                  notifier.setQuality('HD (320kbps)');
                  StorageService.setStreamQuality('HD (320kbps)');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.network_wifi),
                title: const Text('Standard Quality (128 kbps)'),
                trailing: currentQuality.contains('Standard') ? const Icon(Icons.check, color: AppColors.primaryOrange) : null,
                onTap: () {
                  notifier.setQuality('Standard (128kbps)');
                  StorageService.setStreamQuality('Standard (128kbps)');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.data_saver_on),
                title: const Text('Data Saver (64 kbps)'),
                trailing: currentQuality.contains('Data Saver') ? const Icon(Icons.check, color: AppColors.primaryOrange) : null,
                onTap: () {
                  notifier.setQuality('Data Saver (64kbps)');
                  StorageService.setStreamQuality('Data Saver (64kbps)');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
