class ScheduleModel {
  final String id;
  final String day;
  final String showTitle;
  final String presenter;
  final String startTime;
  final String endTime;
  final bool isLiveNow;

  const ScheduleModel({
    required this.id,
    required this.day,
    required this.showTitle,
    required this.presenter,
    required this.startTime,
    required this.endTime,
    this.isLiveNow = false,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? '',
      day: json['day'] ?? '',
      showTitle: json['showTitle'] ?? '',
      presenter: json['presenter'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isLiveNow: json['isLiveNow'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'showTitle': showTitle,
      'presenter': presenter,
      'startTime': startTime,
      'endTime': endTime,
      'isLiveNow': isLiveNow,
    };
  }
}
