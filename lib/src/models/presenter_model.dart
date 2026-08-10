class PresenterModel {
  final String id;
  final String name;
  final String showName;
  final String image;
  final String bio;
  final String instagram;
  final String twitter;
  final String facebook;

  const PresenterModel({
    required this.id,
    required this.name,
    required this.showName,
    required this.image,
    required this.bio,
    this.instagram = '',
    this.twitter = '',
    this.facebook = '',
  });

  factory PresenterModel.fromJson(Map<String, dynamic> json) {
    return PresenterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      showName: json['showName'] ?? '',
      image: json['image'] ?? '',
      bio: json['bio'] ?? '',
      instagram: json['instagram'] ?? '',
      twitter: json['twitter'] ?? '',
      facebook: json['facebook'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'showName': showName,
      'image': image,
      'bio': bio,
      'instagram': instagram,
      'twitter': twitter,
      'facebook': facebook,
    };
  }
}
