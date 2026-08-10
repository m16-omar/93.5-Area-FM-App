import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../common/widgets/mini_player.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/empty_state.dart';
import '../../../common/widgets/network_image.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : AppColors.textPrimaryLight, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all as read',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondaryDark,
            labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.inter(fontSize: 14),
            indicatorColor: AppColors.primary,
            indicatorWeight: 2,
            dividerHeight: 0,
            tabs: const [Tab(text: 'All'), Tab(text: 'Mentions')],
          ),
        ),
      ),
      bottomNavigationBar: const MiniPlayerWidget(),
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
          return TabBarView(
            controller: _tabController,
            children: [
              _NotificationList(notifications: notifications, isDark: isDark),
              _NotificationList(
                notifications: notifications.where((n) => n.type == 'mention').toList(),
                isDark: isDark,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final bool isDark;
  const _NotificationList({required this.notifications, required this.isDark});

  // Group notifications by Today / Yesterday / This Week
  Map<String, List<NotificationModel>> get _grouped {
    final Map<String, List<NotificationModel>> grouped = {};
    for (final n in notifications) {
      final group = n.timeGroup.isNotEmpty ? n.timeGroup : 'Earlier';
      grouped.putIfAbsent(group, () => []).add(n);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;
    final groupKeys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: groupKeys.length,
      itemBuilder: (context, gi) {
        final group = groupKeys[gi];
        final items = grouped[group]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                group,
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...items.map((n) => _NotificationTile(notification: n, isDark: isDark)),
          ],
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final bool isDark;
  const _NotificationTile({required this.notification, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? (isUnread ? AppColors.surfaceDark2 : AppColors.surfaceDark)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark.withValues(alpha: 0.4) : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unread dot
          if (isUnread)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 8),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          else
            const SizedBox(width: 16),
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _iconForType(notification.type),
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 2),
                Text(
                  notification.body,
                  style: GoogleFonts.inter(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  notification.timeAgo,
                  style: GoogleFonts.inter(
                    color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Optional thumbnail image
          if (notification.imageUrl.isNotEmpty) ...[
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomNetworkImage(
                imageUrl: notification.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
          ] else if (notification.hasAction)
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMutedDark),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'show':
        return Icons.mic_rounded;
      case 'event':
        return Icons.local_activity_outlined;
      case 'news':
        return Icons.newspaper_rounded;
      case 'podcast':
        return Icons.headphones_rounded;
      case 'music':
        return Icons.music_note_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }
}
