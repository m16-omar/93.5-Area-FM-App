class EpisodeModel {
  final String id;
  final String title;
  final String duration;
  final String publishDate;
  final String audioUrl;
  final String description;

  const EpisodeModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.publishDate,
    required this.audioUrl,
    required this.description,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      publishDate: json['publishDate'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'publishDate': publishDate,
      'audioUrl': audioUrl,
      'description': description,
    };
  }
}
