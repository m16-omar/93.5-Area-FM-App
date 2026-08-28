import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/mini_player.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/helpers/url_helper.dart';
import '../../../const/app_colors.dart';
import '../../providers/presenter_provider.dart';
import '../../models/presenter_model.dart';

class PresenterDetailsView extends ConsumerStatefulWidget {
  final String id;

  const PresenterDetailsView({super.key, required this.id});

  @override
  ConsumerState<PresenterDetailsView> createState() => _PresenterDetailsViewState();
}

class _PresenterDetailsViewState extends ConsumerState<PresenterDetailsView> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final presenterAsync = ref.watch(presenterDetailsProvider(widget.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF030D18) : const Color(0xFFFAFAFA),
      appBar: AreaFMAppBar(
        title: 'Presenter Profile',
        showBack: true,
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              size: 22,
            ),
            onPressed: () {
              setState(() => _isBookmarked = !_isBookmarked);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isBookmarked ? 'Saved to bookmarks' : 'Removed from bookmarks'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              size: 20,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing profile link...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      bottomNavigationBar: const MiniPlayerWidget(),
      body: presenterAsync.when(
        loading: () => const AppLoader(message: 'Loading profile...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(presenterDetailsProvider(widget.id)),
        ),
        data: (presenter) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Card
              _PresenterHeroCard(presenter: presenter, size: size),

              const SizedBox(height: 22),

              // 2. About Section
              Text(
                'About ${presenter.name}',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                presenter.about.isNotEmpty ? presenter.about : presenter.bio,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.55,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
                ),
              ),

              const SizedBox(height: 18),

              // 3. Stats Row (4 Info Cards)
              _PresenterStatsRow(presenter: presenter, isDark: isDark),

              const SizedBox(height: 24),

              // 4. Shows Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shows',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/shows'),
                    child: Text(
                      'View All',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF5500),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _PresenterShowTile(presenter: presenter, isDark: isDark),

              const SizedBox(height: 22),

              // 5. Bio Section
              Text(
                'Bio',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                presenter.bio,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.55,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresenterHeroCard extends StatelessWidget {
  final PresenterModel presenter;
  final Size size;

  const _PresenterHeroCard({required this.presenter, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: presenter.gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: presenter.gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ambient sound wave frequency lines behind portrait
            Positioned(
              right: 10,
              top: 40,
              bottom: 60,
              width: size.width * 0.45,
              child: Opacity(
                opacity: 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(12, (i) {
                    final h = [0.3, 0.6, 0.8, 0.45, 0.9, 0.7, 0.95, 0.6, 0.75, 0.4, 0.65, 0.3][i];
                    return Container(
                      width: 2.5,
                      height: 120 * h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Presenter portrait image
            Positioned(
              right: -10,
              top: 0,
              bottom: 45,
              width: size.width * 0.58,
              child: CustomNetworkImage(
                imageUrl: presenter.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // Left-to-right fade gradient for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    presenter.gradientColors.first,
                    presenter.gradientColors.first.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.52, 1.0],
                ),
              ),
            ),

            // Bottom gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.3, 0.65, 1.0],
                ),
              ),
            ),

            // ON AIR Badge
            if (presenter.isOnAir)
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5500),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ON AIR',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Left Content (Name, Show, Time, Tagline)
            Positioned(
              left: 14,
              right: 14,
              top: presenter.isOnAir ? 46 : 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    presenter.name,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    presenter.showName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled_rounded,
                        color: Color(0xFFFF7A1A),
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        presenter.timeSlot,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: size.width * 0.54,
                    child: Text(
                      presenter.tagline.isNotEmpty
                          ? presenter.tagline
                          : 'Bringing the finest music and entertainment to your airwaves.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Social Media Action Pills at bottom of card
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Row(
                children: [
                  Expanded(
                    child: _SocialPill(
                      icon: Icons.camera_alt_outlined,
                      label: 'Instagram',
                      onTap: () => UrlHelper.launchURL(presenter.instagram),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _SocialPill(
                      isX: true,
                      label: 'X (Twitter)',
                      onTap: () => UrlHelper.launchURL(presenter.twitter),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _SocialPill(
                      icon: Icons.music_note_rounded,
                      label: 'TikTok',
                      onTap: () => UrlHelper.launchURL(presenter.tiktok),
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

class _SocialPill extends StatelessWidget {
  final IconData? icon;
  final bool isX;
  final String label;
  final VoidCallback onTap;

  const _SocialPill({
    this.icon,
    this.isX = false,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.14),
            width: 0.8,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isX)
              const Text(
                '𝕏',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              )
            else
              Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _PresenterStatsRow extends StatelessWidget {
  final PresenterModel presenter;
  final bool isDark;

  const _PresenterStatsRow({
    required this.presenter,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.cake_outlined,
            iconColor: const Color(0xFFFF5500),
            label: 'Birthday',
            value: presenter.birthday,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.mic_rounded,
            iconColor: const Color(0xFFFF5500),
            label: 'On Air Since',
            value: presenter.onAirSince,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.radio_rounded,
            iconColor: const Color(0xFFFF5500),
            label: 'Show',
            value: presenter.showName,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFFFF5500),
            label: 'Location',
            value: presenter.location,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C1929) : const Color(0xFFFFF7F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF162942) : const Color(0xFFFFE8DC),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9.5,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PresenterShowTile extends StatelessWidget {
  final PresenterModel presenter;
  final bool isDark;

  const _PresenterShowTile({
    required this.presenter,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C1929) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF162942) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          // Show thumbnail
          Container(
            width: 85,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: presenter.gradientColors,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomNetworkImage(
                    imageUrl: presenter.image,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  if (presenter.isOnAir)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5500),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'ON AIR',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Show Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  presenter.showName,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  presenter.days,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF5500),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      presenter.timeSlot,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Play button
          GestureDetector(
            onTap: () => context.push('/radio_player'),
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5500),
                shape: BoxShape.circle,
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
    );
  }
}
