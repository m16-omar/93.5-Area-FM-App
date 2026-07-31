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
}

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
    required this.episodes,
  });
}
