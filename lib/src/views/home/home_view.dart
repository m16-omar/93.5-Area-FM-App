import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../providers/home_provider.dart';
import '../../routes/route_names.dart';
import '../drawer/app_drawer.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import 'widgets/hero_section.dart';
import 'widgets/live_radio_section.dart';
import 'widgets/explore_grid.dart';
import 'widgets/featured_shows.dart';
import 'widgets/latest_news.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDataFutureProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      extendBodyBehindAppBar: false,
      drawer: const AppDrawer(),
      appBar: AreaFMAppBar(
        notificationCount: 3,
        showSearch: true,
        onSearchTap: () => context.push('/shows'),
      ),
      body: homeDataAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => const AppLoader(message: 'Loading station content...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(homeDataFutureProvider),
        ),
        data: (data) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(homeDataFutureProvider);
            await ref.read(homeDataFutureProvider.future);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Sliding Hero Header Banner Carousel
              SliverToBoxAdapter(child: HeroSectionWidget(data: data)),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // 2. ON AIR NOW Live Radio Section
              SliverToBoxAdapter(
                child: LiveRadioSectionWidget(show: data.featuredShows.first),
              ),

              // 3. EXPLORE Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: ExploreGridWidget(),
                ),
              ),

              // 4. FEATURED SHOWS Section
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'FEATURED SHOWS',
                  onSeeAll: () => context.push(RouteNames.shows),
                  isDark: isDark,
                ),
              ),
              SliverToBoxAdapter(
                child: FeaturedShowsWidget(shows: data.featuredShows),
              ),

              // 5. LATEST NEWS Section
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'LATEST NEWS',
                  onSeeAll: () => context.push(RouteNames.blog),
                  isDark: isDark,
                ),
              ),
              SliverToBoxAdapter(
                child: LatestNewsWidget(news: data.latestNews),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final bool isDark;
  const _SectionHeader({required this.title, this.onSeeAll, this.isDark = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.bebasNeue(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
