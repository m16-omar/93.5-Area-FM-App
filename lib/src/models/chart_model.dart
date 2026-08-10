class ChartModel {
  final int rank;
  final String title;
  final String artist;
  final String albumCover;
  final int votes;
  final String audioUrl;
  final String peakPosition;

  const ChartModel({
    required this.rank,
    required this.title,
    required this.artist,
    required this.albumCover,
    required this.votes,
    required this.audioUrl,
    required this.peakPosition,
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      rank: json['rank'] ?? 0,
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      albumCover: json['albumCover'] ?? '',
      votes: json['votes'] ?? 0,
      audioUrl: json['audioUrl'] ?? '',
      peakPosition: json['peakPosition'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'title': title,
      'artist': artist,
      'albumCover': albumCover,
      'votes': votes,
      'audioUrl': audioUrl,
      'peakPosition': peakPosition,
    };
  }
}
