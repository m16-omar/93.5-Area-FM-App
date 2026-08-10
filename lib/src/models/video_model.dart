class VideoModel {
  final String id;
  final String title;
  final String duration;
  final String publishDate;
  final String views;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;

  const VideoModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.publishDate,
    required this.views,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.description,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      publishDate: json['publishDate'] ?? '',
      views: json['views'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'publishDate': publishDate,
      'views': views,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'description': description,
    };
  }
}
