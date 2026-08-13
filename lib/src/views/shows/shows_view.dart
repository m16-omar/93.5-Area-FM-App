import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/shows_provider.dart';
import '../../models/show_model.dart';
import '../drawer/app_drawer.dart';
import '../../../common/widgets/network_image.dart';

class ShowsView extends ConsumerStatefulWidget {
  const ShowsView({super.key});

  @override
  ConsumerState<ShowsView> createState() => _ShowsViewState();
}

class _ShowsViewState extends ConsumerState<ShowsView> {
  String _selectedCategory = 'All Shows';

  @override
  Widget build(BuildContext context) {
    final showsAsync = ref.watch(showsListProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF060B14) : AppColors.backgroundLight,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3, showSearch: true),
      body: showsAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => const AppLoader(message: 'Loading shows...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(showsListProvider),
        ),
        data: (shows) {
          final filteredShows = _selectedCategory == 'All Shows'
              ? shows
              : shows.where((s) => s.genre.toLowerCase().contains(_selectedCategory.toLowerCase().replaceAll(' shows', '')) ||
                  s.title.toLowerCase().contains(_selectedCategory.toLowerCase())).toList();
          final displayShows = filteredShows.isNotEmpty ? filteredShows : shows;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(showsListProvider);
              await ref.read(showsListProvider.future);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
              // Header title graphic
              SliverToBoxAdapter(
                child: _SliverHeaderGraphic(size: size),
              ),
              // Category filter chips matching mockup
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: _ShowsCategoryChips(
                    selectedCategory: _selectedCategory,
                    onSelected: (cat) => setState(() => _selectedCategory = cat),
                  ),
                ),
              ),
              // NOW ON AIR hero banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: _NowOnAirBanner(show: displayShows.first),
                ),
              ),
              // All Shows section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Shows',
                        style: GoogleFonts.poppins(
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Shows list matching mockup layout
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final show = displayShows[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: _ShowListTile(
                        show: show,
                        onTap: () => context.push('/show_details/${show.id}'),
                      ),
                    );
                  },
                  childCount: displayShows.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        );
      },
    ),
  );
  }
}

class _SliverHeaderGraphic extends StatelessWidget {
  final Size size;
  const _SliverHeaderGraphic({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      height: 145,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF085264),
            Color(0xFF0B6B82),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF085264).withValues(alpha: 0.4),
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
            // Studio Mic Artwork with smooth fade mask on left edge
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
            // Smooth Left Gradient for crisp text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF085264),
                      const Color(0xFF085264).withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 0.85],
                  ),
                ),
              ),
            ),
            // SHOWS Header Content Column
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SHOWS',
                    style: GoogleFonts.outfit(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tune in to your favourite shows on\n',
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.5),
                        ),
                        TextSpan(
                          text: '93.5 AREA FM.',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

/// Compact category filter chips matching Mockup Image 2
class _ShowsCategoryChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const _ShowsCategoryChips({
    required this.selectedCategory,
    required this.onSelected,
  });

  static const List<Map<String, dynamic>> _categories = [
    {'label': 'All Shows', 'icon': null},
    {'label': 'Talk Shows', 'icon': Icons.mic_none_rounded},
    {'label': 'Music', 'icon': Icons.music_note_rounded},
    {'label': 'News', 'icon': Icons.article_outlined},
    {'label': 'Sports', 'icon': Icons.emoji_events_outlined},
    {'label': 'Lifestyle', 'icon': Icons.favorite_border_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final String label = cat['label'];
          final IconData? icon = cat['icon'];
          final bool isSelected = label == selectedCategory;

          return GestureDetector(
            onTap: () => onSelected(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? const Color(0xFF0A1C24) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0)),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 11.5,
                      color: isSelected ? Colors.white : const Color(0xFF0B6B82),
                    ),
                    const SizedBox(width: 3),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : AppColors.textPrimaryLight),
                      fontSize: 10,
                      letterSpacing: -0.2,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// NOW ON AIR Hero Card matching Mockup Image 2
class _NowOnAirBanner extends StatelessWidget {
  final ShowModel show;
  const _NowOnAirBanner({required this.show});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF04181E),
            Color(0xFF085264),
            Color(0xFF0B6B82),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF085264).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Extended Studio Background Image (DJ + Mic + Blue Wall on right side)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.62,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                AppAssets.showsScreenCarousel,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF085264),
                ),
              ),
            ),
          ),
          // Dark Left Gradient Overlay matching brand blue palette
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF031014),
                    const Color(0xFF051D24).withValues(alpha: 0.95),
                    const Color(0xFF085264).withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 0.7, 1.0],
                ),
              ),
            ),
          ),
          // Top-to-bottom subtle gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          // Content Layout matching reference image typography & styling
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 4. NOW ON AIR badge - rounded orange pill shape
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sensors_rounded, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'NOW ON AIR',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // 1. Title: "Morning Drive & Hype" - sleek, medium-bold sans-serif title
                Text(
                  show.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // 2. Subtitle: "with DJ Big Shaq" - orange color #FF4500
                Text(
                  'with ${show.presenter}',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                // 3. Time: "06:00 AM - 10:00 AM" - light gray with clock icon
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 15, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      show.airTime,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // 4. LISTEN LIVE button - rounded orange pill shape with play arrow
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'LISTEN LIVE',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 5. LIVE indicator - orange waveform icon + orange LIVE text
          Positioned(
            right: 18,
            bottom: 18,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 4),
                Text(
                  'LIVE',
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Show List Tile matching Mockup Image 2: dark navy card, blue presenter name, description, air time & blue play circle button
class _ShowListTile extends StatelessWidget {
  final ShowModel show;
  final VoidCallback onTap;
  const _ShowListTile({required this.show, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0A1C24) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show Image Artwork
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: CustomNetworkImage(
                imageUrl: show.image,
                width: 80,
                height: 80,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 12),
            // Middle Details Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      show.title,
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'with ${show.presenter}',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0B6B82), // Deep Teal presenter name
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      show.description.isNotEmpty
                          ? show.description
                          : 'The perfect mix of music, traffic updates and conversations to keep you moving.',
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Right Column: Air Time, Three dots & Deep Teal Play Circle
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
              child: SizedBox(
                height: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Top right air time & menu icon
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          show.airTime.contains('-')
                              ? '${show.airTime.split('-')[0].trim()}\n- ${show.airTime.split('-')[1].trim()}'
                              : show.airTime,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0B6B82), // Deep Teal air time
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.more_vert_rounded,
                          color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
                          size: 18,
                        ),
                      ],
                    ),
                    // Deep Teal Play Circle Button
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0B6B82),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
