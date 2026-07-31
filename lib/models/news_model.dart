class NewsModel {
  final String id;
  final String title;
  final String category;
  final String author;
  final String date;
  final String image;
  final String summary;
  final String content;
  final List<String> tags;

  const NewsModel({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.date,
    required this.image,
    required this.summary,
    required this.content,
    required this.tags,
  });
}
