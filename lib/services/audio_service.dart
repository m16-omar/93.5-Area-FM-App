import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track_model.dart';
import '../services/data_repository.dart';

class AudioPlayerService extends ChangeNotifier {
  late AudioPlayer _audioPlayer;
  
  TrackModel _currentTrack = DataRepository.liveStreamTrack;
  bool _isPlaying = false;
  bool _isBuffering = false;
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

  TrackModel get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  bool get isBuffering => _isBuffering;
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

  Future<void> playTrack(TrackModel track) async {
    try {
      if (_currentTrack.id == track.id && _audioPlayer.audioSource != null) {
        return togglePlayPause();
      }

      _currentTrack = track;
      _isBuffering = true;
      notifyListeners();

      await _audioPlayer.setUrl(track.audioUrl);
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
