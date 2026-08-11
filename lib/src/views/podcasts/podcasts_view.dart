import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
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
      extendBodyBehindAppBar: true,
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700,
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
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700,
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
      height: size.height * 0.28,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -20,
            top: 0,
            bottom: 0,
            child: Image.network(
              'https://images.unsplash.com/photo-1478737270239-2f02b77fc618?auto=format&fit=crop&w=400&q=80',
              fit: BoxFit.cover,
              width: size.width * 0.55,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.backgroundDark,
                  AppColors.backgroundDark.withValues(alpha: 0.85),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundDark,
                  Colors.transparent,
                  AppColors.backgroundDark,
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'PODCASTS',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 42,
                      color: Colors.white,
                      letterSpacing: 2,
                      height: 1.0,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Listen to all your favourite shows ',
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                        ),
                        TextSpan(
                          text: 'anytime, anywhere.',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        width: 155,
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
                      Container(
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
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${podcast.episodesCount} Episodes',
                        style: GoogleFonts.inter(color: Colors.white60, fontSize: 10),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
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
                        color: Colors.white,
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
                        color: AppColors.textSecondaryDark,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      podcast.description.isNotEmpty
                          ? podcast.description
                          : 'Recently added',
                      style: GoogleFonts.inter(
                        color: AppColors.textMutedDark,
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
                      color: AppColors.navyBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(height: 4),
                  const Icon(Icons.more_vert, color: AppColors.textMutedDark, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
