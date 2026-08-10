class ShowModel {
  final String id;
  final String title;
  final String presenter;
  final String airTime;
  final String days;
  final String image;
  final String description;
  final String genre;

  const ShowModel({
    required this.id,
    required this.title,
    required this.presenter,
    required this.airTime,
    required this.days,
    required this.image,
    required this.description,
    required this.genre,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      presenter: json['presenter'] ?? '',
      airTime: json['airTime'] ?? '',
      days: json['days'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      genre: json['genre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'presenter': presenter,
      'airTime': airTime,
      'days': days,
      'image': image,
      'description': description,
      'genre': genre,
    };
  }
}
