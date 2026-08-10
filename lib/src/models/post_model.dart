class PostModel {
  final String id;
  final String title;
  final String category;
  final String author;
  final String date;
  final String image;
  final String summary;
  final String content;
  final List<String> tags;

  const PostModel({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.date,
    required this.image,
    required this.summary,
    required this.content,
    this.tags = const [],
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      author: json['author'] ?? '',
      date: json['date'] ?? '',
      image: json['image'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'author': author,
      'date': date,
      'image': image,
      'summary': summary,
      'content': content,
      'tags': tags,
    };
  }
}
