class ChartTrackModel {
  final int rank;
  final String title;
  final String artist;
  final String albumCover;
  final int votes;
  final String audioUrl;
  final String peakPosition;

  const ChartTrackModel({
    required this.rank,
    required this.title,
    required this.artist,
    required this.albumCover,
    required this.votes,
    required this.audioUrl,
    required this.peakPosition,
  });
}
