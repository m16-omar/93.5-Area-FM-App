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
    String rawImage = json['image']?.toString() ?? '';
    if (rawImage.isNotEmpty && !rawImage.startsWith('http') && !rawImage.startsWith('assets/')) {
      rawImage = 'https://res.cloudinary.com/dgjzsen3g/image/upload/$rawImage';
    }

    String parsedDate = json['formatted_date']?.toString() ??
        json['date']?.toString() ??
        json['created_at']?.toString() ??
        '';
    if (parsedDate.contains('T') || (parsedDate.contains('-') && parsedDate.contains(':'))) {
      try {
        final dt = DateTime.parse(parsedDate.split('.').first);
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        parsedDate = '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
      } catch (_) {}
    }

    String authorName = 'Editorial Team';
    if (json['author_details'] is Map && json['author_details']['name'] != null) {
      authorName = json['author_details']['name'];
    } else if (json['author'] != null && json['author'].toString().isNotEmpty) {
      final a = json['author'].toString();
      authorName = a == 'admin' ? 'Area FM News Desk' : a;
    }

    return PostModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      category: json['category']?.toString() ?? 'General',
      author: authorName,
      date: parsedDate.isNotEmpty ? parsedDate : 'Recent',
      image: rawImage,
      summary: json['excerpt'] ?? json['summary'] ?? '',
      content: json['content'] ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [json['category']?.toString() ?? 'News'],
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
