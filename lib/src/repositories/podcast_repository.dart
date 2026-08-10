import '../models/podcast_model.dart';
import '../models/episode_model.dart';

class PodcastRepository {
  Future<List<PodcastModel>> getPodcasts() async {
    return const [
      PodcastModel(
        id: 'pod1',
        title: 'The Fan Zone #1',
        showName: 'Sports Extra',
        host: 'Alex Rivera',
        category: 'Sports & Talk',
        coverImage: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=600&q=80',
        description: 'Deep dive into weekend league matches, player interviews, and match tactical breakdowns.',
        episodesCount: 12,
        episodes: [
          EpisodeModel(
            id: 'ep101',
            title: 'Season Preview & Derby Breakdown',
            duration: '42 min',
            publishDate: 'July 28, 2026',
            audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/15/audio_c8c8a6a43e.mp3?filename=funky-synthwave-111668.mp3',
            description: 'Analyzing team transfers, tactical formations, and derby predictions.',
          ),
          EpisodeModel(
            id: 'ep102',
            title: 'Exclusive Interview with Top Striker',
            duration: '35 min',
            publishDate: 'July 21, 2026',
            audioUrl: 'https://cdn.pixabay.com/download/audio/2022/01/18/audio_d0a13f69d2.mp3?filename=tropical-house-11524.mp3',
            description: 'Behind the scenes story of championship dreams and personal journey.',
          ),
        ],
      ),
      PodcastModel(
        id: 'pod2',
        title: 'Tech & Tomorrow',
        showName: 'Future Tech',
        host: 'Elena Vance',
        category: 'Technology',
        coverImage: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=600&q=80',
        description: 'Exploring AI innovations, mobile ecosystems, and the digital economy.',
        episodesCount: 8,
        episodes: [
          EpisodeModel(
            id: 'ep201',
            title: 'Generative AI & Mobile Apps',
            duration: '28 min',
            publishDate: 'July 29, 2026',
            audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/10/audio_c8c8a6a43e.mp3?filename=synthwave-111668.mp3',
            description: 'How AI-driven tools are reshaping mobile UX and interactive broadcast radio.',
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
