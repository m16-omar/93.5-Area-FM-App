import 'package:flutter/material.dart';
import '../../../models/notification_model.dart';
import 'notification_tile.dart';

class NotificationSectionWidget extends StatelessWidget {
  final String title;
  final List<NotificationModel> notifications;

  const NotificationSectionWidget({
    super.key,
    required this.title,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Column(
          children: notifications
              .map((n) => NotificationTileWidget(notification: n, onTap: () {}))
              .toList(),
        ),
      ],
    );
  }
}
