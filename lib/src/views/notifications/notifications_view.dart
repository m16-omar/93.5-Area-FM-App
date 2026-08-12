import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/empty_state.dart';
import '../../../common/widgets/network_image.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';
import '../drawer/app_drawer.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  String _selectedFilter = 'All';

  final List<String> _filters = const ['All', 'Unread', 'Shows', 'Podcasts', 'Events'];

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsListProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 0),
      body: notificationsAsync.when(
        loading: () => const AppLoader(message: 'Loading notifications...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(notificationsListProvider),
        ),
        data: (notifications) {
          // Filter items based on selected category chip
          final filtered = notifications.where((n) {
            if (_selectedFilter == 'Unread') return !n.isRead;
            if (_selectedFilter == 'Shows') return n.type == 'show';
            if (_selectedFilter == 'Podcasts') return n.type == 'podcast';
            if (_selectedFilter == 'Events') return n.type == 'event';
            return true;
          }).toList();

          final unreadCount = notifications.where((n) => !n.isRead).length;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Banner Graphic
              SliverToBoxAdapter(
                child: _NotificationsHeaderBanner(size: size),
              ),

              // Filter Chips & Mark All As Read Row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _filters.map((filter) {
                              final isSelected = _selectedFilter == filter;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark ? const Color(0xFF0C1728) : Colors.white),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : (isDark ? const Color(0xFF162742) : const Color(0xFFE2E8F0)),
                                    ),
                                  ),
                                  child: Text(
                                    filter,
                                    style: GoogleFonts.inter(
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark ? Colors.white70 : AppColors.textSecondaryLight),
                                      fontSize: 12.5,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      if (unreadCount > 0)
                        GestureDetector(
                          onTap: () {
                            ref.read(notificationsListProvider.notifier).markAllAsRead();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              'Mark all as read',
                              style: GoogleFonts.inter(
                                color: AppColors.primary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Empty State
              if (filtered.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: EmptyStateWidget(
                      title: 'No Notifications',
                      message: 'You have no notifications in this filter category.',
                    ),
                  ),
                )
              else
                // Notification List Grouped by Time
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = filtered[index];
                      final showGroupHeader = index == 0 ||
                          filtered[index - 1].timeGroup != item.timeGroup;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showGroupHeader)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                              child: Text(
                                item.timeGroup.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          _NotificationCard(
                            notification: item,
                            isDark: isDark,
                            onTap: () {
                              ref.read(notificationsListProvider.notifier).markAsRead(item.id);
                              if (item.type == 'show') {
                                context.push('/shows');
                              } else if (item.type == 'podcast') {
                                context.push('/podcasts');
                              } else if (item.type == 'event') {
                                context.push('/events');
                              }
                            },
                          ),
                        ],
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          );
        },
      ),
    );
  }
}

class _NotificationsHeaderBanner extends StatelessWidget {
  final Size size;
  const _NotificationsHeaderBanner({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      height: 145,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF001F54),
            Color(0xFF003882),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF001F54).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Studio Mic Artwork
            Positioned(
              right: 0,
              top: -10,
              bottom: -10,
              width: size.width * 0.55,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.transparent, Colors.white],
                    stops: [0.0, 0.35],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  AppAssets.studioMicOnly,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
            ),
            // Smooth Left Gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF001F54),
                      const Color(0xFF001F54).withValues(alpha: 0.75),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.48, 0.88],
                  ),
                ),
              ),
            ),
            // Header Title & Subtitle Column
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NOTIFICATIONS',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Stay updated with live shows, podcasts, and giveaways.',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.isDark,
    required this.onTap,
  });

  Color _badgeColor(String type) {
    switch (type) {
      case 'show':
        return const Color(0xFF0055FF);
      case 'podcast':
        return AppColors.primary;
      case 'event':
        return const Color(0xFF8B5CF6);
      case 'music':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF0055FF);
    }
  }

  IconData _badgeIcon(String type) {
    switch (type) {
      case 'show':
        return Icons.mic_rounded;
      case 'podcast':
        return Icons.headphones_rounded;
      case 'event':
        return Icons.local_activity_outlined;
      case 'music':
        return Icons.music_note_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final iconColor = _badgeColor(notification.type);
    final icon = _badgeIcon(notification.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? (isUnread ? const Color(0xFF0F1E36) : const Color(0xFF0C1728))
            : (isUnread ? const Color(0xFFEFF6FF) : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.5)
              : (isDark ? const Color(0xFF162742) : const Color(0xFFE2E8F0)),
          width: isUnread ? 1.2 : 1.0,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type Icon Badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Main Content Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isUnread) ...[
                            Container(
                              width: 7,
                              height: 7,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                          Expanded(
                            child: Text(
                              notification.title,
                              style: GoogleFonts.inter(
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                fontSize: 13.5,
                                fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: GoogleFonts.inter(
                          color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                          fontSize: 12,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.timeAgo,
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Image Thumbnail (if available)
                if (notification.imageUrl.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomNetworkImage(
                      imageUrl: notification.imageUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
