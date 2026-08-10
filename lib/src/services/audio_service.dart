import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/radio_stream_model.dart';
import '../../const/app_constants.dart';

class AudioPlayerService extends ChangeNotifier {
  late AudioPlayer _audioPlayer;

  RadioStreamModel _currentTrack = const RadioStreamModel(
    id: 'live_stream',
    title: 'The Big Breakfast Club',
    artist: 'DJ Big Shaq & MC Sparkle',
    showName: '93.5 Area FM Live Stream',
    coverUrl: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
    streamUrl: AppConstants.defaultStreamUrl,
    isLive: true,
  );

  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _isDismissed = false;
  double _volume = 0.8;
  bool _isMuted = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String _streamQuality = 'HD (320kbps)';

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  AudioPlayerService() {
    _initAudioPlayer();
  }

  RadioStreamModel get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  bool get isBuffering => _isBuffering;
  bool get isDismissed => _isDismissed;
  double get volume => _volume;
  bool get isMuted => _isMuted;
  Duration get position => _position;
  Duration get duration => _duration;
  String get streamQuality => _streamQuality;

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isBuffering = state.processingState == ProcessingState.buffering ||
          state.processingState == ProcessingState.loading;
      notifyListeners();
    });

    _positionSubscription = _audioPlayer.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _durationSubscription = _audioPlayer.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });
  }

  void dismissMiniPlayer() {
    _isDismissed = true;
    notifyListeners();
  }

  void showMiniPlayer() {
    _isDismissed = false;
    notifyListeners();
  }

  Future<void> playTrack(RadioStreamModel track) async {
    try {
      _isDismissed = false;
      if (_currentTrack.id == track.id && _audioPlayer.audioSource != null) {
        return togglePlayPause();
      }

      _currentTrack = track;
      _isBuffering = true;
      notifyListeners();

      await _audioPlayer.setUrl(track.streamUrl);
      await _audioPlayer.setVolume(_isMuted ? 0.0 : _volume);
      await _audioPlayer.play();
    } catch (e) {
      if (kDebugMode) print('Audio play error: $e');
      _isBuffering = false;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    try {
      _isDismissed = false;
      if (_audioPlayer.audioSource == null) {
        await playTrack(_currentTrack);
        return;
      }

      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      if (kDebugMode) print('Toggle play error: $e');
    }
  }

  Future<void> seek(Duration pos) async {
    await _audioPlayer.seek(pos);
  }

  Future<void> setVolume(double val) async {
    _volume = val;
    if (_volume > 0) _isMuted = false;
    await _audioPlayer.setVolume(_isMuted ? 0.0 : _volume);
    notifyListeners();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _audioPlayer.setVolume(_isMuted ? 0.0 : _volume);
    notifyListeners();
  }

  void setQuality(String quality) {
    _streamQuality = quality;
    notifyListeners();
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
