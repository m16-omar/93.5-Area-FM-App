import 'package:flutter_riverpod/legacy.dart';
import '../services/audio_service.dart';

export '../controllers/radio_player_controller.dart';

final audioPlayerServiceProvider = ChangeNotifierProvider<AudioPlayerService>((ref) {
  return AudioPlayerService();
});
