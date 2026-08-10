import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../providers/podcast_provider.dart';
import '../../providers/radio_player_provider.dart';
import '../../models/radio_stream_model.dart';
import 'widgets/episode_card.dart';

class PodcastDetailsView extends ConsumerWidget {
  final String id;

  const PodcastDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastAsync = ref.watch(podcastDetailsProvider(id));

    return Scaffold(
      appBar: const CustomAppBar(title: 'Podcast Show'),
      body: podcastAsync.when(
        loading: () => const AppLoader(),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (podcast) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomNetworkImage(
                    imageUrl: podcast.coverImage,
                    width: 120,
                    height: 120,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcast.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hosted by ${podcast.host}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          podcast.category,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                podcast.description,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const Divider(height: 32),
              Text(
                'Episodes (${podcast.episodes.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Column(
                children: podcast.episodes
                    .map(
                      (ep) => EpisodeCardWidget(
                        episode: ep,
                        onPlayTap: () {
                          final track = RadioStreamModel(
                            id: ep.id,
                            title: ep.title,
                            artist: podcast.host,
                            showName: podcast.title,
                            coverUrl: podcast.coverImage,
                            streamUrl: ep.audioUrl,
                            isLive: false,
                          );
                          ref.read(audioPlayerServiceProvider).playTrack(track);
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
