import '../models/notification_model.dart';
import '../../const/app_assets.dart';

class NotificationRepository {
  Future<List<NotificationModel>> getNotifications() async {
    return const [
      NotificationModel(
        id: 'n1',
        title: 'The Morning Rush is Live On-Air!',
        body: 'Tune in now with DJ Ace for top morning hits, banter and traffic updates.',
        timeAgo: '15m ago',
        timeGroup: 'Today',
        isRead: false,
        type: 'show',
        imageUrl: AppAssets.show1,
        hasAction: true,
      ),
      NotificationModel(
        id: 'n2',
        title: 'New Podcast Episode Released',
        body: 'Afternoon Vibes Ep #102 with Tolu: Midweek Chill & Afrobeat Jams is live.',
        timeAgo: '2h ago',
        timeGroup: 'Today',
        isRead: false,
        type: 'podcast',
        imageUrl: AppAssets.show2,
        hasAction: true,
      ),
      NotificationModel(
        id: 'n3',
        title: 'Exclusive Concert Ticket Giveaway!',
        body: 'Stand a chance to win VIP tickets for Area FM Mega Concert 2026.',
        timeAgo: '1d ago',
        timeGroup: 'Yesterday',
        isRead: true,
        type: 'event',
        imageUrl: AppAssets.banner,
        hasAction: true,
      ),
      NotificationModel(
        id: 'n4',
        title: 'Trending Music Chart Updated',
        body: 'Check out the Top 10 Afrobeats Countdown of the week on Drive Time.',
        timeAgo: '1d ago',
        timeGroup: 'Yesterday',
        isRead: true,
        type: 'music',
        imageUrl: AppAssets.show3,
        hasAction: true,
      ),
      NotificationModel(
        id: 'n5',
        title: 'Welcome to 93.5 AREA FM!',
        body: 'Your home for non-stop live radio streaming, podcasts, news and events.',
        timeAgo: '3d ago',
        timeGroup: 'Earlier',
        isRead: true,
        type: 'general',
      ),
    ];
  }
}
