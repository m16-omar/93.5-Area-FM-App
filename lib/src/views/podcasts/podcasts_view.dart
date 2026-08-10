import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/podcast_provider.dart';
import 'widgets/podcast_card.dart';

class PodcastsView extends ConsumerWidget {
  const PodcastsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastsAsync = ref.watch(podcastsListProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Podcasts & On-Demand', showBackButton: false),
      body: podcastsAsync.when(
        loading: () => const AppLoader(message: 'Loading podcasts...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(podcastsListProvider),
        ),
        data: (podcasts) => GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: podcasts.length,
          itemBuilder: (context, index) => PodcastCardWidget(
            podcast: podcasts[index],
            onTap: () => context.push('/podcast_details/${podcasts[index].id}'),
          ),
        ),
      ),
    );
  }
}
