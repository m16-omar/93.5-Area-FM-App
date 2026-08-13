import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/widgets/mini_player.dart';
import '../../../common/widgets/app_bottom_navigation.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../../const/app_constants.dart';
import '../../models/radio_stream_model.dart';
import '../../providers/shows_provider.dart';
import '../../providers/radio_player_provider.dart';
import '../../routes/route_names.dart';
import '../drawer/app_drawer.dart';

class ShowDetailsView extends ConsumerWidget {
  final String id;

  const ShowDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAsync = ref.watch(showDetailsProvider(id));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      drawer: const AppDrawer(),
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
              context.go('/shows');
            }
          },
        ),
        title: Text(
          'Show Details',
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.bookmark_border_rounded,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              size: 22,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              size: 22,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayerWidget(),
          AppBottomNavigation(
            currentIndex: 1,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go(RouteNames.home);
                  break;
                case 1:
                  context.go(RouteNames.shows);
                  break;
                case 2:
                  context.push(RouteNames.radioPlayer);
                  break;
                case 3:
                  context.go(RouteNames.podcasts);
                  break;
                case 4:
                  context.go(RouteNames.settings);
                  break;
              }
            },
          ),
        ],
      ),
      body: showAsync.when(
        loading: () => const AppLoader(message: 'Loading show details...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(showDetailsProvider(id)),
        ),
        data: (show) {
          final isDriveTime = show.id == 'show3' || show.title.toLowerCase().contains('drive');
          final displayTitle = isDriveTime ? 'Drive Time' : show.title;
          final displayPresenter = isDriveTime ? 'DJ Ace' : show.presenter;
          final displayImage = isDriveTime ? AppAssets.show3 : show.image;
          final displayAirTime = isDriveTime ? '4:00 PM – 7:00 PM' : show.airTime;
          final displayDays = isDriveTime ? 'Weekdays' : show.days;
          final displayCategory = isDriveTime ? 'Music & Talk' : show.genre;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO HEADER CARD
                _ShowHeroHeaderCard(
                  title: displayTitle,
                  presenter: displayPresenter,
                  image: displayImage,
                  airTime: displayAirTime,
                  days: displayDays,
                  description: 'The perfect way to drive home. Great music, traffic updates, street vibes and good conversation.',
                  onPlay: () {
                    ref.read(audioPlayerServiceProvider).playTrack(
                      RadioStreamModel(
                        id: show.id,
                        title: displayTitle,
                        artist: displayPresenter,
                        showName: displayTitle,
                        coverUrl: displayImage,
                        streamUrl: AppConstants.defaultStreamUrl,
                        isLive: true,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // 2. ABOUT THE SHOW SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About the Show',
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$displayTitle is your daily companion on the road home. $displayPresenter brings you the biggest hits, traffic updates, trending topics, and all the vibes to help you unwind after a long day.',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          height: 1.45,
                          color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 3. STATS GRID (4 Cards)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoGridCard(
                          isDark: isDark,
                          icon: Icons.calendar_today_rounded,
                          label: 'Schedule',
                          value: displayDays,
                          subValue: displayAirTime,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _InfoGridCard(
                          isDark: isDark,
                          icon: Icons.mic_rounded,
                          label: 'Host',
                          value: displayPresenter,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _InfoGridCard(
                          isDark: isDark,
                          icon: Icons.radio_rounded,
                          label: 'Category',
                          value: displayCategory,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _InfoGridCard(
                          isDark: isDark,
                          icon: Icons.share_outlined,
                          label: 'Language',
                          value: 'English',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. TODAY'S SHOWS SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Shows",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See All',
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0055FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Episodes List
                _EpisodeListItem(
                  isDark: isDark,
                  isUnread: true,
                  image: displayImage,
                  title: 'Midweek Mix',
                  subtitle: 'Great hits to keep you going this Wednesday.',
                  timeAgo: 'May 7, 2025 • 2h 58m',
                  onPlay: () {},
                ),
                _EpisodeListItem(
                  isDark: isDark,
                  isUnread: true,
                  image: displayImage,
                  title: 'Traffic + Vibes',
                  subtitle: 'Traffic updates, new music and good vibes all the way.',
                  timeAgo: 'May 6, 2025 • 2h 45m',
                  onPlay: () {},
                ),
                _EpisodeListItem(
                  isDark: isDark,
                  isUnread: true,
                  image: displayImage,
                  title: 'Feel Good Friday',
                  subtitle: "It's Friday! Let's end the week on a high note.",
                  timeAgo: 'May 2, 2025 • 2h 50m',
                  onPlay: () {},
                ),
                _EpisodeListItem(
                  isDark: isDark,
                  isUnread: false,
                  image: displayImage,
                  title: 'Throwback Thursday',
                  subtitle: 'Classic throwbacks and nostalgic jams from the vault.',
                  timeAgo: 'Apr 28, 2025 • 2h 30m',
                  onPlay: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ShowHeroHeaderCard extends StatelessWidget {
  final String title;
  final String presenter;
  final String image;
  final String airTime;
  final String days;
  final String description;
  final VoidCallback onPlay;

  const _ShowHeroHeaderCard({
    required this.title,
    required this.presenter,
    required this.image,
    required this.airTime,
    required this.days,
    required this.description,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF001C48),
            Color(0xFF003882),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF001C48).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Graphic Artwork Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CustomNetworkImage(
              imageUrl: image,
              width: size.width * 0.36,
              height: 155,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),

          // Right Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Status Badge + Overflow 3 Dots Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0055FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'ON AIR',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Show Title
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),

                // Presenter
                Text(
                  'with $presenter',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                // Time Info Row
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      airTime,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 19),
                  child: Text(
                    days,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Short Description & Floating Play Button Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          height: 1.3,
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: onPlay,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0055FF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0055FF).withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGridCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final String value;
  final String? subValue;

  const _InfoGridCard({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C1728) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF162742) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFF0055FF),
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: const Color(0xFF0055FF),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subValue != null) ...[
            const SizedBox(height: 1),
            Text(
              subValue!,
              style: GoogleFonts.inter(
                fontSize: 9.5,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _EpisodeListItem extends StatelessWidget {
  final bool isDark;
  final bool isUnread;
  final String image;
  final String title;
  final String subtitle;
  final String timeAgo;
  final VoidCallback onPlay;

  const _EpisodeListItem({
    required this.isDark,
    required this.isUnread,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C1728) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF162742) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Left Unread Dot
            SizedBox(
              width: 12,
              child: isUnread
                  ? Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0055FF),
                        shape: BoxShape.circle,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomNetworkImage(
                imageUrl: image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Text Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeAgo,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Play Circular Outline Button
            GestureDetector(
              onTap: onPlay,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0055FF).withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF0055FF),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 4),

            // 3 Vertical Dots Overflow Menu
            Icon(
              Icons.more_vert_rounded,
              color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
