class TrackModel {
  final String id;
  final String title;
  final String artist;
  final String showName;
  final String presenterName;
  final String image;
  final String audioUrl;
  final bool isLiveStream;
  final Duration? duration;
  final String? genre;

  const TrackModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.showName,
    required this.presenterName,
    required this.image,
    required this.audioUrl,
    this.isLiveStream = false,
    this.duration,
    this.genre,
  });

  static const TrackModel liveDefault = TrackModel(
    id: 'live_stream',
    title: 'Morning Vibe Blast',
    artist: 'Jordan Carter & DJ Spark',
    showName: 'Morning Vibe Blast',
    presenterName: 'Jordan Carter',
    image: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80',
    audioUrl: 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=lofi-study-112191.mp3',
    isLiveStream: true,
    genre: 'Urban & Hip Hop',
  );
}
