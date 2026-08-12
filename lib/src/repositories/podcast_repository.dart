import '../models/podcast_model.dart';
import '../models/episode_model.dart';
import '../../const/app_assets.dart';

class PodcastRepository {
  Future<List<PodcastModel>> getPodcasts() async {
    return const [
      PodcastModel(
        id: 'pod1',
        title: 'The Morning Rush',
        showName: 'The Morning Rush',
        host: 'DJ Ace',
        category: 'Daily',
        coverImage: AppAssets.show1,
        description: 'Wake up with energy, great tunes, news breakdown and traffic updates.',
        episodesCount: 234,
        episodes: [
          EpisodeModel(
            id: 'ep101',
            title: 'Morning Hype & Traffic Special',
            duration: '45 min',
            publishDate: 'August 12, 2026',
            audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/15/audio_c8c8a6a43e.mp3?filename=funky-synthwave-111668.mp3',
            description: 'Analyzing today\'s big headlines and top trending jams.',
          ),
        ],
      ),
      PodcastModel(
        id: 'pod2',
        title: 'Afternoon Vibes',
        showName: 'Afternoon Vibes',
        host: 'Tolu',
        category: 'Weekly',
        coverImage: AppAssets.show2,
        description: 'Smooth afternoon selections, lifestyle talks and listener call-ins.',
        episodesCount: 102,
        episodes: [
          EpisodeModel(
            id: 'ep201',
            title: 'Midweek Chill & Afrobeat Hits',
            duration: '38 min',
            publishDate: 'August 11, 2026',
            audioUrl: 'https://cdn.pixabay.com/download/audio/2022/01/18/audio_d0a13f69d2.mp3?filename=tropical-house-11524.mp3',
            description: 'Relax with Tolu featuring top Afrobeats and lifestyle banter.',
          ),
        ],
      ),
      PodcastModel(
        id: 'pod3',
        title: 'Drive Time',
        showName: 'Drive Time',
        host: 'Mike',
        category: 'Daily',
        coverImage: AppAssets.show3,
        description: 'Your evening commute companion with high-energy hits and banter.',
        episodesCount: 189,
        episodes: [
          EpisodeModel(
            id: 'ep301',
            title: 'Evening Rush Hour Countdown',
            duration: '50 min',
            publishDate: 'August 10, 2026',
            audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/10/audio_c8c8a6a43e.mp3?filename=synthwave-111668.mp3',
            description: 'Counting down the top 5 requested tracks of the day with Mike.',
          ),
        ],
      ),
      PodcastModel(
        id: 'pod4',
        title: 'Area Nights',
        showName: 'Area Nights',
        host: 'DJ Big Shaq',
        category: 'Weekly',
        coverImage: AppAssets.show4,
        description: 'Late night club mixes, guest DJs and non-stop party anthems.',
        episodesCount: 145,
        episodes: [
          EpisodeModel(
            id: 'ep401',
            title: 'Weekend Party Warmup Mix',
            duration: '60 min',
            publishDate: 'August 08, 2026',
            audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/15/audio_c8c8a6a43e.mp3?filename=funky-synthwave-111668.mp3',
            description: 'Non-stop high energy club hits with DJ Big Shaq.',
          ),
        ],
      ),
    ];
  }

  Future<PodcastModel> getPodcastById(String id) async {
    final podcasts = await getPodcasts();
    return podcasts.firstWhere((p) => p.id == id, orElse: () => podcasts.first);
  }
}
