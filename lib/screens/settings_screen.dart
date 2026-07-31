import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../services/audio_service.dart';

class SettingsScreen extends StatelessWidget {
  final ValueNotifier<bool> isDarkModeNotifier;

  const SettingsScreen({super.key, required this.isDarkModeNotifier});

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioPlayerService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS & CONTACT'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text('APP PREFERENCES', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryOrange, fontSize: 12, letterSpacing: 1)),
          ),

          // Theme Switcher
          ValueListenableBuilder<bool>(
            valueListenable: isDarkModeNotifier,
            builder: (context, isDark, child) {
              return SwitchListTile(
                secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: AppColors.primaryOrange),
                title: const Text('Dark Mode Theme'),
                subtitle: const Text('Switch between sleek dark and clean light modes'),
                value: isDark,
                onChanged: (val) {
                  isDarkModeNotifier.value = val;
                },
              );
            },
          ),

          // Audio Stream Quality
          ListTile(
            leading: const Icon(Icons.high_quality, color: AppColors.primaryBlue),
            title: const Text('Audio Stream Quality'),
            subtitle: Text('Current: ${audioService.streamQuality}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              _showQualityPicker(context, audioService);
            },
          ),

          const Divider(height: 32),

          // Contact Studio Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text('CONNECT WITH STUDIO', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryOrange, fontSize: 12, letterSpacing: 1)),
          ),

          ListTile(
            leading: const Icon(Icons.chat, color: Color(0xFF25D366)),
            title: const Text('WhatsApp Studio Hotline'),
            subtitle: const Text('+234 800 935 2732'),
            onTap: () async {
              final url = Uri.parse('https://wa.me/${AppConstants.whatsappNumber}');
              if (await canLaunchUrl(url)) await launchUrl(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: AppColors.primaryBlue),
            title: const Text('Call Studio Direct'),
            subtitle: const Text('+234 800 935 AREA'),
            onTap: () async {
              final url = Uri.parse('tel:${AppConstants.studioPhone}');
              if (await canLaunchUrl(url)) await launchUrl(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.email, color: AppColors.primaryOrange),
            title: const Text('Email Studio & Enquiries'),
            subtitle: const Text(AppConstants.studioEmail),
            onTap: () async {
              final url = Uri.parse('mailto:${AppConstants.studioEmail}');
              if (await canLaunchUrl(url)) await launchUrl(url);
            },
          ),

          const Divider(height: 32),

          // About Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text('ABOUT 93.5 AREA FM', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryOrange, fontSize: 12, letterSpacing: 1)),
          ),

          const ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.primaryBlue),
            title: Text('App Version'),
            subtitle: Text('93.5 Area FM Mobile v1.0.0 (Build 1)'),
          ),
          const ListTile(
            leading: Icon(Icons.tune, color: AppColors.primaryBlue),
            title: Text('Audio Engine'),
            subtitle: Text('Powered by High-Efficiency Live AAC/MP3 Stream'),
          ),
        ],
      ),
    );
  }

  static void _showQualityPicker(BuildContext context, AudioPlayerService audioService) {
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
              const Text('Audio Stream Quality', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.hd, color: AppColors.primaryOrange),
                title: const Text('High Definition (320 kbps)'),
                trailing: audioService.streamQuality.contains('HD') ? const Icon(Icons.check, color: AppColors.primaryOrange) : null,
                onTap: () {
                  audioService.setQuality('HD (320kbps)');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.network_wifi),
                title: const Text('Standard Quality (128 kbps)'),
                trailing: audioService.streamQuality.contains('Standard') ? const Icon(Icons.check, color: AppColors.primaryOrange) : null,
                onTap: () {
                  audioService.setQuality('Standard (128kbps)');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.data_saver_on),
                title: const Text('Data Saver (64 kbps)'),
                trailing: audioService.streamQuality.contains('Data Saver') ? const Icon(Icons.check, color: AppColors.primaryOrange) : null,
                onTap: () {
                  audioService.setQuality('Data Saver (64kbps)');
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
