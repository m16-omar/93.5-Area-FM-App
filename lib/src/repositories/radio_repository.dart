import '../models/radio_stream_model.dart';
import '../../const/app_constants.dart';

class RadioRepository {
  Future<RadioStreamModel> getLiveStreamDetails() async {
    return const RadioStreamModel(
      id: 'live_stream_main',
      title: 'The Big Breakfast Club',
      artist: 'DJ Big Shaq & MC Sparkle',
      showName: '93.5 Area FM Live Stream',
      coverUrl: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
      streamUrl: AppConstants.defaultStreamUrl,
      isLive: true,
    );
  }
}
