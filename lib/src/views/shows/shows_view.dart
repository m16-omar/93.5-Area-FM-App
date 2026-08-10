import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/app_search_filter.dart';
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
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final _filters = ['All', 'Morning', 'Afternoon', 'Evening', 'Night', 'Weekend'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showsAsync = ref.watch(showsListProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3),
      body: showsAsync.when(
        loading: () => const AppLoader(message: 'Loading shows...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(showsListProvider),
        ),
        data: (shows) => CustomScrollView(
          slivers: [
            // Page header
            SliverToBoxAdapter(
              child: _ShowsPageHeader(size: size),
            ),
            // Search + filter bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    AppSearchBar(controller: _searchController, hint: 'Search shows...'),
                    const SizedBox(height: 14),
                    AppFilterChips(
                      filters: _filters,
                      selected: _selectedFilter,
                      onChanged: (v) => setState(() => _selectedFilter = v),
                    ),
                  ],
                ),
              ),
            ),
            // NOW ON AIR banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: _NowOnAirBanner(show: shows.first),
              ),
            ),
            // Shows section header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Shows',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'See All',
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Shows list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final show = shows[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: _ShowListTile(
                      show: show,
                      onTap: () => context.push('/show_details/${show.id}'),
                    ),
                  );
                },
                childCount: shows.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

/// Page header with decorative mic image + waveform (same pattern as all screens)
class _ShowsPageHeader extends StatelessWidget {
  final Size size;
  const _ShowsPageHeader({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.28,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -30,
            top: 0,
            bottom: 0,
            child: Image.network(
              AppAssets.podcastPlaceholder,
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
                  AppColors.backgroundDark.withValues(alpha: 0.8),
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
                  AppColors.backgroundDark.withValues(alpha: 0.6),
                  AppColors.backgroundDark,
                ],
                stops: const [0.0, 0.3, 0.75, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'SHOWS',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Your favourite shows from ',
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                        ),
                        TextSpan(
                          text: '93.5 AREA FM.',
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

class _NowOnAirBanner extends StatelessWidget {
  final ShowModel show;
  const _NowOnAirBanner({required this.show});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: AppColors.heroGradient,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CustomNetworkImage(
              imageUrl: show.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  AppColors.navyBlue.withValues(alpha: 0.85),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.onAirRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'NOW ON AIR',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        show.title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${show.presenter} • ${show.airTime}',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShowListTile extends StatelessWidget {
  final ShowModel show;
  final VoidCallback onTap;
  const _ShowListTile({required this.show, required this.onTap});

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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: CustomNetworkImage(
                imageUrl: show.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    show.presenter,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        show.airTime,
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        show.days,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondaryDark,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded, color: AppColors.textSecondaryDark),
            ),
          ],
        ),
      ),
    );
  }
}


