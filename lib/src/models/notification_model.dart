class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final String timeGroup;
  final bool isRead;
  final String type;        // show, event, news, podcast, music, general
  final String imageUrl;
  final bool hasAction;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    this.timeGroup = 'Today',
    this.isRead = false,
    this.type = 'general',
    this.imageUrl = '',
    this.hasAction = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      timeGroup: json['timeGroup'] ?? 'Today',
      isRead: json['isRead'] ?? false,
      type: json['type'] ?? 'general',
      imageUrl: json['imageUrl'] ?? '',
      hasAction: json['hasAction'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timeAgo': timeAgo,
      'timeGroup': timeGroup,
      'isRead': isRead,
      'type': type,
      'imageUrl': imageUrl,
      'hasAction': hasAction,
    };
  }
}
