import '../models/notification_model.dart';

class NotificationRepository {
  Future<List<NotificationModel>> getNotifications() async {
    return const [
      NotificationModel(
        id: 'n1',
        title: 'Morning Hype Live Stream Started!',
        body: 'Tune in now to join DJ Big Shaq and win exciting giveaways.',
        timeAgo: '10m ago',
        isRead: false,
      ),
      NotificationModel(
        id: 'n2',
        title: 'New Podcast Episode Released',
        body: 'Episode #101 of The Fan Zone is live.',
        timeAgo: '2h ago',
        isRead: true,
      ),
    ];
  }
}
