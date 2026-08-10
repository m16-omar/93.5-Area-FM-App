import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/home_provider.dart';
import '../drawer/app_drawer.dart';
import 'widgets/hero_section.dart';
import 'widgets/live_radio_section.dart';
import 'widgets/featured_shows.dart';
import 'widgets/latest_news.dart';
import 'widgets/podcast_section.dart';
import 'widgets/upcoming_events.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDataFutureProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: CustomAppBar(
        title: '93.5 Area FM',
        showBackButton: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: homeDataAsync.when(
        loading: () => const AppLoader(message: 'Loading station content...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(homeDataFutureProvider),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () async => ref.refresh(homeDataFutureProvider),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroSectionWidget(
                  title: data.featuredShows.first.title,
                  subtitle: data.featuredShows.first.presenter,
                  imageUrl: data.featuredShows.first.image,
                ),
                const SizedBox(height: 20),
                const LiveRadioSectionWidget(),
                const SizedBox(height: 24),
                FeaturedShowsWidget(shows: data.featuredShows),
                const SizedBox(height: 24),
                PodcastSectionWidget(podcasts: data.featuredPodcasts),
                const SizedBox(height: 24),
                LatestNewsWidget(news: data.latestNews),
                const SizedBox(height: 24),
                UpcomingEventsWidget(events: data.upcomingEvents),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
