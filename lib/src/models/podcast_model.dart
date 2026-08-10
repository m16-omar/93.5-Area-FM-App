import 'episode_model.dart';

class PodcastModel {
  final String id;
  final String title;
  final String showName;
  final String host;
  final String category;
  final String coverImage;
  final String description;
  final int episodesCount;
  final List<EpisodeModel> episodes;

  const PodcastModel({
    required this.id,
    required this.title,
    required this.showName,
    required this.host,
    required this.category,
    required this.coverImage,
    required this.description,
    required this.episodesCount,
    this.episodes = const [],
  });

  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    return PodcastModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      showName: json['showName'] ?? '',
      host: json['host'] ?? '',
      category: json['category'] ?? '',
      coverImage: json['coverImage'] ?? '',
      description: json['description'] ?? '',
      episodesCount: json['episodesCount'] ?? 0,
      episodes: (json['episodes'] as List<dynamic>?)
              ?.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'showName': showName,
      'host': host,
      'category': category,
      'coverImage': coverImage,
      'description': description,
      'episodesCount': episodesCount,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}
