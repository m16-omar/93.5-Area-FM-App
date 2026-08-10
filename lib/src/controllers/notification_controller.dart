import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/notification_repository.dart';
import '../models/notification_model.dart';

final notificationRepositoryProvider = Provider((ref) => NotificationRepository());

final notificationsListProvider = FutureProvider<List<NotificationModel>>((ref) async {
  return await ref.watch(notificationRepositoryProvider).getNotifications();
});
