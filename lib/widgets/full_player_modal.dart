import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../core/theme/app_theme.dart';
import '../services/audio_service.dart';
import 'sound_wave_visualizer.dart';

class FullPlayerModal extends StatelessWidget {
  const FullPlayerModal({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioPlayerService>(context);
    final track = audioService.currentTrack;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.darkGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Drag Indicator
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              // Header bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Column(
                    children: [
                      Text(
                        'PLAYING RADIO',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '93.5 AREA FM',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white),
                    onPressed: () {
                      Share.share('Listening to ${track.title} on 93.5 Area FM! Join live: https://areafm.com');
                    },
                  ),
                ],
              ),
              const Spacer(),

              // Album Art with Animated Soundwave Glow
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: audioService.isPlaying
                              ? AppColors.primaryOrange.withOpacity(0.4)
                              : AppColors.primaryBlue.withOpacity(0.3),
                          blurRadius: 32,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: track.image,
                      width: 240,
                      height: 240,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.darkCard,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.primaryOrange),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.secondaryBlue,
                        child: const Icon(Icons.radio, color: Colors.white, size: 60),
                      ),
                    ),
                  ),
                  if (track.isLiveStream)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.sensors, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'LIVE ON AIR',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),

              // Song & Show Metadata
              Text(
                track.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Presenter: ${track.presenterName}',
                style: const TextStyle(
                  color: AppColors.textDarkMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Visualizer Bar
              SoundWaveVisualizer(
                isPlaying: audioService.isPlaying,
                color: AppColors.primaryOrange,
                barCount: 14,
                height: 28,
              ),
              const SizedBox(height: 20),

              // Volume Slider & Mute Button
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      audioService.isMuted ? Icons.volume_off : Icons.volume_down,
                      color: Colors.white,
                    ),
                    onPressed: () => audioService.toggleMute(),
                  ),
                  Expanded(
                    child: Slider(
                      value: audioService.isMuted ? 0.0 : audioService.volume,
                      activeColor: AppColors.primaryOrange,
                      inactiveColor: Colors.white.withOpacity(0.2),
                      onChanged: (val) => audioService.setVolume(val),
                    ),
                  ),
                  const Icon(Icons.volume_up, color: Colors.white),
                ],
              ),
              const SizedBox(height: 20),

              // Main Play Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white, size: 28),
                    onPressed: () {
                      _showQualityPicker(context, audioService);
                    },
                  ),
                  GestureDetector(
                    onTap: () => audioService.togglePlayPause(),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.orangeGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOrange,
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: audioService.isBuffering
                          ? const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                          : Icon(
                              audioService.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
                    onPressed: () {
                      _showShoutoutSnackbar(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  static void _showQualityPicker(BuildContext context, AudioPlayerService audioService) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Audio Stream Quality', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.hd, color: AppColors.primaryOrange),
                title: const Text('High Definition (320 kbps)', style: TextStyle(color: Colors.white)),
                trailing: audioService.streamQuality.contains('HD') ? const Icon(Icons.check, color: AppColors.primaryOrange) : null,
                onTap: () {
                  audioService.setQuality('HD (320kbps)');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.network_wifi, color: Colors.white70),
                title: const Text('Standard Quality (128 kbps)', style: TextStyle(color: Colors.white)),
                trailing: audioService.streamQuality.contains('Standard') ? const Icon(Icons.check, color: AppColors.primaryOrange) : null,
                onTap: () {
                  audioService.setQuality('Standard (128kbps)');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.data_saver_on, color: Colors.white70),
                title: const Text('Data Saver (64 kbps)', style: TextStyle(color: Colors.white)),
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

  static void _showShoutoutSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Send your live shoutout or request to WhatsApp: +234 800 935 2732'),
        backgroundColor: AppColors.secondaryBlue,
      ),
    );
  }
}
