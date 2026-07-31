import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/constants/app_constants.dart';

class TrackItem {
  final String id;
  final String title;
  final String presenter;
  final String showName;
  final String image;
  final String streamUrl;
  final bool isLive;

  const TrackItem({
    required this.id,
    required this.title,
    required this.presenter,
    required this.showName,
    required this.image,
    required this.streamUrl,
    this.isLive = true,
  });

  static const defaultLiveTrack = TrackItem(
    id: 'live_stream',
    title: 'Morning Vibe Blast',
    presenter: 'Jordan Carter & DJ Spark',
    showName: 'Morning Vibe Blast',
    image: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80',
    streamUrl: AppConstants.defaultStreamUrl,
    isLive: true,
  );
}

class AudioPlayerState {
  final TrackItem currentTrack;
  final bool isPlaying;
  final bool isBuffering;
  final double volume;
  final bool isMuted;
  final Duration position;
  final Duration duration;
  final String quality;

  const AudioPlayerState({
    required this.currentTrack,
    this.isPlaying = false,
    this.isBuffering = false,
    this.volume = 0.8,
    this.isMuted = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.quality = 'HD (320kbps)',
  });

  AudioPlayerState copyWith({
    TrackItem? currentTrack,
    bool? isPlaying,
    bool? isBuffering,
    double? volume,
    bool? isMuted,
    Duration? position,
    Duration? duration,
    String? quality,
  }) {
    return AudioPlayerState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      quality: quality ?? this.quality,
    );
  }
}

class AudioPlayerNotifier extends Notifier<AudioPlayerState> {
  late final AudioPlayer _player;

  @override
  AudioPlayerState build() {
    _player = AudioPlayer();
    _initStreams();
    ref.onDispose(() => _player.dispose());
    return const AudioPlayerState(currentTrack: TrackItem.defaultLiveTrack);
  }

  void _initStreams() {
    _player.playerStateStream.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState.playing,
        isBuffering: playerState.processingState == ProcessingState.buffering ||
            playerState.processingState == ProcessingState.loading,
      );
    });

    _player.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _player.durationStream.listen((dur) {
      state = state.copyWith(duration: dur ?? Duration.zero);
    });
  }

  Future<void> playTrack(TrackItem track) async {
    try {
      if (state.currentTrack.id == track.id && _player.audioSource != null) {
        return togglePlayPause();
      }

      state = state.copyWith(currentTrack: track, isBuffering: true);
      await _player.setUrl(track.streamUrl);
      await _player.setVolume(state.isMuted ? 0.0 : state.volume);
      await _player.play();
    } catch (e) {
      state = state.copyWith(isBuffering: false);
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.audioSource == null) {
      await playTrack(state.currentTrack);
      return;
    }

    if (state.isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> setVolume(double val) async {
    state = state.copyWith(volume: val, isMuted: val == 0);
    await _player.setVolume(val);
  }

  Future<void> toggleMute() async {
    final nextMuted = !state.isMuted;
    state = state.copyWith(isMuted: nextMuted);
    await _player.setVolume(nextMuted ? 0.0 : state.volume);
  }

  void setQuality(String quality) {
    state = state.copyWith(quality: quality);
  }
}

final audioPlayerProvider = NotifierProvider<AudioPlayerNotifier, AudioPlayerState>(AudioPlayerNotifier.new);
