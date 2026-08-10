import '../models/chart_model.dart';

class ChartsRepository {
  Future<List<ChartModel>> getTopCharts() async {
    return const [
      ChartModel(
        rank: 1,
        title: 'City Lights',
        artist: 'K-Star ft. Luna',
        albumCover: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=300&q=80',
        votes: 14250,
        audioUrl: 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=lofi-study-112191.mp3',
        peakPosition: '#1 for 3 weeks',
      ),
      ChartModel(
        rank: 2,
        title: 'Midnight Drive',
        artist: 'Metro Groove',
        albumCover: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=format&fit=crop&w=300&q=80',
        votes: 12890,
        audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/15/audio_c8c8a6a43e.mp3?filename=funky-synthwave-111668.mp3',
        peakPosition: '#2',
      ),
      ChartModel(
        rank: 3,
        title: 'Afro Rhythm',
        artist: 'DJ Bazz',
        albumCover: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=300&q=80',
        votes: 11400,
        audioUrl: 'https://cdn.pixabay.com/download/audio/2022/01/18/audio_d0a13f69d2.mp3?filename=tropical-house-11524.mp3',
        peakPosition: '#1',
      ),
    ];
  }
}
