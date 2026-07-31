class ScheduleItem {
  final String id;
  final String showTitle;
  final String presenter;
  final String day;
  final String timeSlot;
  final String image;
  final String genre;
  final String description;
  final bool isLiveNow;

  const ScheduleItem({
    required this.id,
    required this.showTitle,
    required this.presenter,
    required this.day,
    required this.timeSlot,
    required this.image,
    required this.genre,
    required this.description,
    this.isLiveNow = false,
  });
}
