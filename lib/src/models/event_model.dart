class EventModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String bannerImage;
  final String description;
  final String ticketUrl;

  const EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.bannerImage,
    required this.description,
    this.ticketUrl = '',
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      bannerImage: json['bannerImage'] ?? '',
      description: json['description'] ?? '',
      ticketUrl: json['ticketUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'location': location,
      'bannerImage': bannerImage,
      'description': description,
      'ticketUrl': ticketUrl,
    };
  }
}
