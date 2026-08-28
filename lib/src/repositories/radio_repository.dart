import '../models/radio_stream_model.dart';
import '../../const/app_constants.dart';
import '../../const/app_assets.dart';

class RadioRepository {
  Future<RadioStreamModel> getLiveStreamDetails() async {
    return const RadioStreamModel(
      id: 'live_stream_main',
      title: 'The Morning Rush',
      artist: 'Big P & DJ Big Shaq',
      showName: '93.5 Area FM Live Stream',
      coverUrl: AppAssets.show4,
      streamUrl: AppConstants.defaultStreamUrl,
      isLive: true,
    );
  }
}
