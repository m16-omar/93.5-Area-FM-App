import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/empty_state.dart';
import '../../providers/notification_provider.dart';
import 'widgets/notification_tile.dart';

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsListProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
      body: notificationsAsync.when(
        loading: () => const AppLoader(message: 'Loading notifications...'),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyStateWidget(
              title: 'No Notifications',
              message: 'You have no new notifications right now.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) => NotificationTileWidget(
              notification: notifications[index],
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
