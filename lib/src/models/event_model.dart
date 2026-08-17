class EventModel {
  final String id;
  final String title;
  final String date;
  final String month;
  final String day;
  final String weekday;
  final String time;
  final String location;
  final String bannerImage;
  final String description;
  final String ticketUrl;
  final bool isUpcoming;
  final bool isBookmarked;

  const EventModel({
    required this.id,
    required this.title,
    required this.date,
    this.month = 'MAY',
    this.day = '25',
    this.weekday = 'SAT',
    required this.time,
    required this.location,
    required this.bannerImage,
    required this.description,
    this.ticketUrl = '',
    this.isUpcoming = true,
    this.isBookmarked = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      month: json['month'] ?? 'MAY',
      day: json['day'] ?? '25',
      weekday: json['weekday'] ?? 'SAT',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      bannerImage: json['bannerImage'] ?? '',
      description: json['description'] ?? '',
      ticketUrl: json['ticketUrl'] ?? '',
      isUpcoming: json['isUpcoming'] ?? true,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'month': month,
      'day': day,
      'weekday': weekday,
      'time': time,
      'location': location,
      'bannerImage': bannerImage,
      'description': description,
      'ticketUrl': ticketUrl,
      'isUpcoming': isUpcoming,
      'isBookmarked': isBookmarked,
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? date,
    String? month,
    String? day,
    String? weekday,
    String? time,
    String? location,
    String? bannerImage,
    String? description,
    String? ticketUrl,
    bool? isUpcoming,
    bool? isBookmarked,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      month: month ?? this.month,
      day: day ?? this.day,
      weekday: weekday ?? this.weekday,
      time: time ?? this.time,
      location: location ?? this.location,
      bannerImage: bannerImage ?? this.bannerImage,
      description: description ?? this.description,
      ticketUrl: ticketUrl ?? this.ticketUrl,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
