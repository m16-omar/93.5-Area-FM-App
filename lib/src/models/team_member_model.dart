class TeamMemberModel {
  final String id;
  final String name;
  final String role;
  final String image;
  final String bio;
  final String email;

  const TeamMemberModel({
    required this.id,
    required this.name,
    required this.role,
    required this.image,
    required this.bio,
    this.email = '',
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] ?? '',
      bio: json['bio'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'image': image,
      'bio': bio,
      'email': email,
    };
  }
}
