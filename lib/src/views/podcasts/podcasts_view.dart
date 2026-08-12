import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/widgets/app_search_filter.dart';
import '../../providers/podcast_provider.dart';
import '../../models/podcast_model.dart';
import '../drawer/app_drawer.dart';

class PodcastsView extends ConsumerStatefulWidget {
  const PodcastsView({super.key});

  @override
  ConsumerState<PodcastsView> createState() => _PodcastsViewState();
}

class _PodcastsViewState extends ConsumerState<PodcastsView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final podcastsAsync = ref.watch(podcastsListProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      extendBodyBehindAppBar: false,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3),
      body: podcastsAsync.when(
        loading: () => const AppLoader(message: 'Loading podcasts...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(podcastsListProvider),
        ),
        data: (podcasts) => CustomScrollView(
          slivers: [
            // Page header
            SliverToBoxAdapter(
              child: _PodcastsHeader(size: size),
            ),
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: AppSearchBar(controller: _searchController, hint: 'Search podcasts, shows, episodes...'),
              ),
            ),
            // Featured Podcasts header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Podcasts',
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'See All',
                      style: GoogleFonts.poppins(
                        color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Featured podcasts horizontal scroll
            SliverToBoxAdapter(
              child: SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: podcasts.length > 4 ? 4 : podcasts.length,
                  itemBuilder: (context, i) => _FeaturedPodcastCard(
                    podcast: podcasts[i],
                    onTap: () => context.push('/podcast_details/${podcasts[i].id}'),
                  ),
                ),
              ),
            ),
            // Latest Episodes header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Latest Episodes',
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'See All',
                      style: GoogleFonts.poppins(
                        color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Latest episodes list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final podcast = podcasts[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: _EpisodeTile(
                      podcast: podcast,
                      onTap: () => context.push('/podcast_details/${podcast.id}'),
                    ),
                  );
                },
                childCount: podcasts.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _PodcastsHeader extends StatelessWidget {
  final Size size;
  const _PodcastsHeader({required this.size});

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
                      const Color(0xFF001F54),
                      const Color(0xFF001F54).withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 0.85],
                  ),
                ),
              ),
            ),
            // PODCASTS Header Content Column
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PODCASTS',
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
                          text: 'Listen to your favourite podcasts on\n',
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

class _FeaturedPodcastCard extends StatelessWidget {
  final PodcastModel podcast;
  final VoidCallback onTap;
  const _FeaturedPodcastCard({required this.podcast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.navyBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CustomNetworkImage(
                imageUrl: podcast.coverImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.88),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  // Orange play button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    podcast.showName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'with ${podcast.host}',
                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Frequency badge
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            podcast.category,
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '${podcast.episodesCount} Episodes',
                          style: GoogleFonts.inter(color: Colors.white60, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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

class _EpisodeTile extends StatelessWidget {
  final PodcastModel podcast;
  final VoidCallback onTap;
  const _EpisodeTile({required this.podcast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.borderDark.withValues(alpha: 0.5) : AppColors.borderLight,
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
            // Cover + play overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: podcast.coverImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 28),
                  ),
                ),
              ],
            ),
            // Episode info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      podcast.title,
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      podcast.showName,
                      style: GoogleFonts.inter(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      podcast.description.isNotEmpty
                          ? podcast.description
                          : 'Recently added',
                      style: GoogleFonts.inter(
                        color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Duration + menu
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.navyBlue : const Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.more_vert,
                    color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                    size: 18,
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
