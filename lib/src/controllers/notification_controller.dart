import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/notification_repository.dart';
import '../models/notification_model.dart';

final notificationRepositoryProvider = Provider((ref) => NotificationRepository());

class NotificationsNotifier extends AsyncNotifier<List<NotificationModel>> {
  @override
  Future<List<NotificationModel>> build() async {
    return await ref.watch(notificationRepositoryProvider).getNotifications();
  }

  void markAllAsRead() {
    final current = state.value ?? [];
    final updated = current.map((n) => NotificationModel(
      id: n.id,
      title: n.title,
      body: n.body,
      timeAgo: n.timeAgo,
      timeGroup: n.timeGroup,
      isRead: true,
      type: n.type,
      imageUrl: n.imageUrl,
      hasAction: n.hasAction,
    )).toList();
    state = AsyncValue.data(updated);
  }

  void markAsRead(String id) {
    final current = state.value ?? [];
    final updated = current.map((n) {
      if (n.id == id) {
        return NotificationModel(
          id: n.id,
          title: n.title,
          body: n.body,
          timeAgo: n.timeAgo,
          timeGroup: n.timeGroup,
          isRead: true,
          type: n.type,
          imageUrl: n.imageUrl,
          hasAction: n.hasAction,
        );
      }
      return n;
    }).toList();
    state = AsyncValue.data(updated);
  }
}

final notificationsListProvider = AsyncNotifierProvider<NotificationsNotifier, List<NotificationModel>>(
  NotificationsNotifier.new,
);

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsListProvider).value ?? [];
  return notifications.where((n) => !n.isRead).length;
});
