import '../models/video_model.dart';

class VideosRepository {
  Future<List<VideoModel>> getVideos() async {
    return const [
      VideoModel(
        id: 'v1',
        title: 'Live Studio Freestyle Battle: Top Rapper Performance',
        duration: '08:45',
        publishDate: 'Aug 02, 2026',
        views: '45.2K',
        thumbnailUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=600&q=80',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description: 'Watch the epic freestyle session live inside 93.5 Area FM main studio.',
      ),
      VideoModel(
        id: 'v2',
        title: 'Behind the Scenes: Morning Show Bloopers & Pranks',
        duration: '12:30',
        publishDate: 'Jul 29, 2026',
        views: '31.8K',
        thumbnailUrl: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description: 'Hilarious off-air moments with DJ Big Shaq and MC Sparkle.',
      ),
    ];
  }

  Future<VideoModel> getVideoById(String id) async {
    final videos = await getVideos();
    return videos.firstWhere((v) => v.id == id, orElse: () => videos.first);
  }
}
