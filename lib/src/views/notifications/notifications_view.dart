import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
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
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            size: 22,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              ref.read(notificationsListProvider.notifier).markAllAsRead();
            },
            child: Text(
              'Mark all as read',
              style: GoogleFonts.inter(
                color: const Color(0xFFFF4500),
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFFFF4500),
                unselectedLabelColor: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
                labelStyle: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w600),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w500),
                indicatorColor: const Color(0xFFFF4500),
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 0,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Mentions'),
                ],
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
              ),
            ],
          ),
        ),
      ),
      body: notificationsAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => const AppLoader(message: 'Loading notifications...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(notificationsListProvider),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return RefreshIndicator(
              color: const Color(0xFFFF4500),
              onRefresh: () async => ref.refresh(notificationsListProvider),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const EmptyStateWidget(
                    title: 'No Notifications',
                    message: 'You have no new notifications right now.',
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFFFF4500),
            onRefresh: () async => ref.refresh(notificationsListProvider),
            child: TabBarView(
              controller: _tabController,
              children: [
                _NotificationList(
                  notifications: notifications.where((n) => !n.isMention).toList(),
                  isDark: isDark,
                ),
                _NotificationList(
                  notifications: notifications.where((n) => n.isMention).toList(),
                  isDark: isDark,
                  isMentionsTab: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NotificationList extends ConsumerWidget {
  final List<NotificationModel> notifications;
  final bool isDark;
  final bool isMentionsTab;

  const _NotificationList({
    required this.notifications,
    required this.isDark,
    this.isMentionsTab = false,
  });

  Map<String, List<NotificationModel>> get _grouped {
    final Map<String, List<NotificationModel>> grouped = {};
    for (final n in notifications) {
      final group = n.timeGroup.isNotEmpty ? n.timeGroup : 'Earlier';
      grouped.putIfAbsent(group, () => []).add(n);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (notifications.isEmpty) {
      return EmptyStateWidget(
        title: isMentionsTab ? 'No Mentions' : 'No Notifications',
        message: isMentionsTab
            ? 'You have no mentions at this time.'
            : 'You have no new notifications right now.',
      );
    }

    final grouped = _grouped;
    final groupKeys = grouped.keys.toList();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 40),
      itemCount: groupKeys.length + (isMentionsTab ? 1 : 0),
      itemBuilder: (context, gi) {
        if (isMentionsTab && gi == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              "Notifications where you've been mentioned.",
              style: GoogleFonts.inter(
                color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }

        final groupIndex = isMentionsTab ? gi - 1 : gi;
        final group = groupKeys[groupIndex];
        final items = grouped[group]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
              child: Text(
                group,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...items.map(
              (n) => _NotificationTile(
                notification: n,
                isDark: isDark,
                onTap: () {
                  ref.read(notificationsListProvider.notifier).markAsRead(n.id);
                  if (n.type == 'mic' || n.type == 'show' || n.type == 'calendar') {
                    context.push('/shows');
                  } else if (n.type == 'podcast') {
                    context.push('/podcasts');
                  } else if (n.type == 'event') {
                    context.push('/events');
                  } else if (n.type == 'settings') {
                    context.push('/settings');
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    // Solid orange for microphone icon, light tint for others (matching prototype)
    final bool isSolidIcon = notification.type == 'mic' || notification.type == 'show';
    final Color iconBg = isSolidIcon
        ? const Color(0xFFFF4500)
        : (isDark ? const Color(0xFF2C160F) : const Color(0xFFFFF0EB));
    final Color iconColor = isSolidIcon ? Colors.white : const Color(0xFFFF4500);

    IconData icon;
    switch (notification.type) {
      case 'mic':
      case 'show':
        icon = Icons.mic_rounded;
        break;
      case 'calendar':
        icon = Icons.calendar_today_rounded;
        break;
      case 'favourite':
        icon = Icons.star_outline_rounded;
        break;
      case 'music':
        icon = Icons.music_note_rounded;
        break;
      case 'event':
        icon = Icons.confirmation_number_outlined;
        break;
      case 'settings':
        icon = Icons.notifications_none_rounded;
        break;
      case 'podcast':
        icon = Icons.headphones_rounded;
        break;
      default:
        icon = Icons.notifications_none_rounded;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Unread Dot
            SizedBox(
              width: 14,
              child: isUnread
                  ? Container(
                      margin: const EdgeInsets.only(top: 18),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4500),
                        shape: BoxShape.circle,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Icon Badge or Mention Avatar Badge
            if (notification.isMention || notification.type == 'mention')
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CustomNetworkImage(
                        imageUrl: notification.avatarUrl.isNotEmpty
                            ? notification.avatarUrl
                            : notification.imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B6B82),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppColors.backgroundDark : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '@',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
            const SizedBox(width: 14),

            // Text Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                      fontSize: 13,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notification.timeAgo,
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right Trailing Thumbnail or Action Chevron
            if (notification.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomNetworkImage(
                  imageUrl: notification.imageUrl,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
