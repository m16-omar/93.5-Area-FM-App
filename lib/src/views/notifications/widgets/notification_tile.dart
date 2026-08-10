import 'package:flutter/material.dart';
import '../../../../common/components/notification_tile.dart';
import '../../../models/notification_model.dart';

class NotificationTileWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTileWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationTile(notification: notification, onTap: onTap);
  }
}
