import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../providers/audio_player_provider.dart';

class LiveRadioScreen extends ConsumerStatefulWidget {
  const LiveRadioScreen({super.key});

  @override
  ConsumerState<LiveRadioScreen> createState() => _LiveRadioScreenState();
}

class _LiveRadioScreenState extends ConsumerState<LiveRadioScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = StorageService.getFavorites().contains('live_stream');
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioPlayerProvider);
    final audioNotifier = ref.read(audioPlayerProvider.notifier);
    final track = audioState.currentTrack;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LIVE RADIO STUDIO'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? AppColors.primaryOrange : Colors.white),
            onPressed: () async {
              await StorageService.toggleFavorite('live_stream');
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              Share.share('Listening to ${track.title} live on Area 93.5 FM! Join: ${AppConstants.webUrl}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Studio Player Deck
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.darkGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.radio_button_checked, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('ON AIR LIVE BROADCAST', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: track.image,
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    track.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text('Presenter: ${track.presenter}', style: const TextStyle(color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 24),

                  // Volume Slider & Mute
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(audioState.isMuted ? Icons.volume_off : Icons.volume_down, color: Colors.white),
                        onPressed: () => audioNotifier.toggleMute(),
                      ),
                      Expanded(
                        child: Slider(
                          value: audioState.isMuted ? 0.0 : audioState.volume,
                          activeColor: AppColors.primaryOrange,
                          inactiveColor: Colors.white24,
                          onChanged: (val) => audioNotifier.setVolume(val),
                        ),
                      ),
                      const Icon(Icons.volume_up, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Play Pause Control Button
                  GestureDetector(
                    onTap: () => audioNotifier.togglePlayPause(),
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.orangeGradient,
                        boxShadow: [
                          BoxShadow(color: AppColors.primaryOrange, blurRadius: 20, spreadRadius: 2),
                        ],
                      ),
                      child: audioState.isBuffering
                          ? const Padding(
                              padding: EdgeInsets.all(22),
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                          : Icon(
                              audioState.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 44,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Studio Hotline Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse('https://wa.me/${AppConstants.whatsappNumber}');
                      if (await canLaunchUrl(url)) await launchUrl(url);
                    },
                    icon: const Icon(Icons.chat, color: Colors.white),
                    label: const Text('WhatsApp Studio'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse('tel:${AppConstants.studioPhone}');
                      if (await canLaunchUrl(url)) await launchUrl(url);
                    },
                    icon: const Icon(Icons.phone, color: Colors.white),
                    label: const Text('Call Studio'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
