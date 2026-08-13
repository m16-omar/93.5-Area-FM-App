import '../models/video_model.dart';
import '../../const/app_assets.dart';

class VideosRepository {
  Future<List<VideoModel>> getVideos() async {
    return const [
      // ── FEATURED VIDEOS ──────────────────────────────────────────
      VideoModel(
        id: 'v1',
        title: 'Big P in the City Live Interview with Rema',
        duration: '08:45',
        publishDate: '2 days ago',
        views: '2.3K',
        thumbnailUrl: AppAssets.show1,
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description: 'Exclusive in-studio interview and live acoustic performance with Rema on 93.5 AREA FM.',
      ),
      VideoModel(
        id: 'v2',
        title: 'AREA Concert 2024 Aftermovie',
        duration: '05:12',
        publishDate: '1 week ago',
        views: '1.8K',
        thumbnailUrl: AppAssets.banner,
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description: 'Highlights and wild moments from the 93.5 AREA FM 2024 annual concert.',
      ),
      VideoModel(
        id: 'v3',
        title: 'The Morning Rush Fun Moments',
        duration: '06:30',
        publishDate: '2 weeks ago',
        views: '1.2K',
        thumbnailUrl: AppAssets.show2,
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description: 'Fun, off-air bloopers and jokes with the Morning Rush crew.',
      ),
      // ── LATEST VIDEOS ────────────────────────────────────────────
      VideoModel(
        id: 'v4',
        title: 'Burna Boy surprises fans at AREA FM',
        duration: '04:22',
        publishDate: '3 days ago',
        views: '3.6K',
        thumbnailUrl: AppAssets.show3,
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description: 'Exclusive performance and interview.',
      ),
      VideoModel(
        id: 'v5',
        title: 'Women in Music: A Conversation',
        duration: '07:18',
        publishDate: '5 days ago',
        views: '2.1K',
        thumbnailUrl: AppAssets.show2,
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description: 'Inspiring stories from women shaping the industry.',
      ),
      VideoModel(
        id: 'v6',
        title: 'Street Talk with Ladi Balogun',
        duration: '05:47',
        publishDate: '1 week ago',
        views: '1.9K',
        thumbnailUrl: AppAssets.show4,
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description: 'Real conversations about real issues.',
      ),
      VideoModel(
        id: 'v7',
        title: 'New Music Friday Top Picks',
        duration: '03:55',
        publishDate: '1 week ago',
        views: '1.5K',
        thumbnailUrl: AppAssets.banner,
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description: 'The hottest new songs you need to hear.',
      ),
    ];
  }

  Future<VideoModel> getVideoById(String id) async {
    final videos = await getVideos();
    return videos.firstWhere((v) => v.id == id, orElse: () => videos.first);
  }
}
