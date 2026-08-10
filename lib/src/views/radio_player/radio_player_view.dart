import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../providers/radio_player_provider.dart';
import '../../services/share_service.dart';
import 'widgets/now_playing.dart';
import 'widgets/player_controls.dart';
import 'widgets/volume_control.dart';

class RadioPlayerView extends ConsumerWidget {
  const RadioPlayerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerService = ref.watch(audioPlayerServiceProvider);
    final track = playerService.currentTrack;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Live Player',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => ShareService.shareContent(
              'Listening live to ${track.title} on 93.5 Area FM!',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(),
              NowPlayingWidget(track: track),
              const Spacer(),
              PlayerControlsWidget(
                isPlaying: playerService.isPlaying,
                isBuffering: playerService.isBuffering,
                onPlayPause: () => playerService.togglePlayPause(),
              ),
              const SizedBox(height: 32),
              VolumeControlWidget(
                volume: playerService.volume,
                isMuted: playerService.isMuted,
                onVolumeChanged: (val) => playerService.setVolume(val),
                onMuteToggle: () => playerService.toggleMute(),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
