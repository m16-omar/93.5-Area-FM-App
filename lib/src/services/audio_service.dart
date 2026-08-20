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
    autoPlayStream();
  }

  Future<void> autoPlayStream() async {
    try {
      _isDismissed = false;
      _isBuffering = true;
      notifyListeners();

      await _audioPlayer.setUrl(_currentTrack.streamUrl);
      await _audioPlayer.setVolume(_isMuted ? 0.0 : _volume);
      await _audioPlayer.play();
    } catch (e) {
      if (kDebugMode) print('Auto-play stream error: $e');
      _isBuffering = false;
      notifyListeners();
    }
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

  // Sleep Timer state
  Timer? _sleepTimer;
  Timer? _sleepTicker;
  int? _sleepTimerSecondsRemaining;

  int? get sleepTimerSecondsRemaining => _sleepTimerSecondsRemaining;
  bool get hasActiveSleepTimer => _sleepTimerSecondsRemaining != null && _sleepTimerSecondsRemaining! > 0;

  void startSleepTimer(int minutes) {
    cancelSleepTimer();
    _sleepTimerSecondsRemaining = minutes * 60;
    notifyListeners();

    _sleepTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sleepTimerSecondsRemaining == null || _sleepTimerSecondsRemaining! <= 1) {
        timer.cancel();
        _sleepTimerSecondsRemaining = 0;
        _audioPlayer.pause();
        notifyListeners();
        _sleepTimerSecondsRemaining = null;
        notifyListeners();
      } else {
        _sleepTimerSecondsRemaining = _sleepTimerSecondsRemaining! - 1;
        notifyListeners();
      }
    });
  }

  void cancelSleepTimer() {
    _sleepTicker?.cancel();
    _sleepTimer?.cancel();
    _sleepTicker = null;
    _sleepTimer = null;
    _sleepTimerSecondsRemaining = null;
    notifyListeners();
  }

  // Equalizer State
  bool _eqEnabled = true;
  String _eqPreset = 'Flat';
  final Map<String, double> _eqBands = {
    '60Hz': 0.0,
    '230Hz': 0.0,
    '910Hz': 0.0,
    '3.6kHz': 0.0,
    '14kHz': 0.0,
  };

  bool get eqEnabled => _eqEnabled;
  String get eqPreset => _eqPreset;
  Map<String, double> get eqBands => Map.unmodifiable(_eqBands);

  void toggleEqEnabled(bool enabled) {
    _eqEnabled = enabled;
    notifyListeners();
  }

  void setEqPreset(String preset) {
    _eqPreset = preset;
    switch (preset) {
      case 'Bass Boost':
        _eqBands['60Hz'] = 6.0;
        _eqBands['230Hz'] = 4.0;
        _eqBands['910Hz'] = 0.0;
        _eqBands['3.6kHz'] = -1.0;
        _eqBands['14kHz'] = -2.0;
        break;
      case 'Pop':
        _eqBands['60Hz'] = -1.0;
        _eqBands['230Hz'] = 2.0;
        _eqBands['910Hz'] = 5.0;
        _eqBands['3.6kHz'] = 3.0;
        _eqBands['14kHz'] = -1.0;
        break;
      case 'Rock':
        _eqBands['60Hz'] = 5.0;
        _eqBands['230Hz'] = 3.0;
        _eqBands['910Hz'] = -1.0;
        _eqBands['3.6kHz'] = 3.0;
        _eqBands['14kHz'] = 5.0;
        break;
      case 'Vocal':
        _eqBands['60Hz'] = -2.0;
        _eqBands['230Hz'] = 0.0;
        _eqBands['910Hz'] = 4.0;
        _eqBands['3.6kHz'] = 4.0;
        _eqBands['14kHz'] = 1.0;
        break;
      case 'Jazz':
        _eqBands['60Hz'] = 3.0;
        _eqBands['230Hz'] = 2.0;
        _eqBands['910Hz'] = -1.0;
        _eqBands['3.6kHz'] = 2.0;
        _eqBands['14kHz'] = 4.0;
        break;
      case 'Flat':
      default:
        _eqBands.updateAll((key, value) => 0.0);
        break;
    }
    notifyListeners();
  }

  void setEqBand(String band, double gain) {
    if (_eqBands.containsKey(band)) {
      _eqBands[band] = gain;
      _eqPreset = 'Custom';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sleepTicker?.cancel();
    _sleepTimer?.cancel();
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
