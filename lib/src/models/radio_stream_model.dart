class RadioStreamModel {
  final String id;
  final String title;
  final String artist;
  final String showName;
  final String coverUrl;
  final String streamUrl;
  final bool isLive;

  const RadioStreamModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.showName,
    required this.coverUrl,
    required this.streamUrl,
    this.isLive = true,
  });

  factory RadioStreamModel.fromJson(Map<String, dynamic> json) {
    return RadioStreamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      showName: json['showName'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      isLive: json['isLive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'showName': showName,
      'coverUrl': coverUrl,
      'streamUrl': streamUrl,
      'isLive': isLive,
    };
  }
}
