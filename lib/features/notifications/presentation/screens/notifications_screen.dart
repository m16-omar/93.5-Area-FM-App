import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {
      'title': 'ON AIR: Morning Vibe Blast is Live!',
      'body': 'Tune in now with Jordan Carter & DJ Spark for your morning Afrobeats countdown.',
      'time': '10 mins ago',
      'icon': 'radio',
    },
    {
      'title': 'Breaking News: New Studio Facility',
      'body': 'Area 93.5 FM upgrades digital stream to 320kbps HD audio quality.',
      'time': '2 hours ago',
      'icon': 'newspaper',
    },
    {
      'title': 'Annual Music Festival Announced',
      'body': 'Get early bird passes for the August 24 concert event.',
      'time': 'Yesterday',
      'icon': 'event',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOTIFICATIONS & ANNOUNCEMENTS'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.15),
                child: Icon(
                  n['icon'] == 'radio'
                      ? Icons.radio
                      : n['icon'] == 'newspaper'
                          ? Icons.newspaper
                          : Icons.event,
                  color: AppColors.primaryOrange,
                ),
              ),
              title: Text(n['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(n['body']!, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
              ),
              trailing: Text(n['time']!, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ),
          );
        },
      ),
    );
  }
}
