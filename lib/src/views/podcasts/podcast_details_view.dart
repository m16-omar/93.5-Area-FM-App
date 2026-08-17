import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/widgets/mini_player.dart';
import '../../../const/app_colors.dart';
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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AreaFMAppBar(
        title: 'Podcast Show',
        showBack: true,
        foregroundColor: isDark ? Colors.white : AppColors.textPrimaryLight,
      ),
      bottomNavigationBar: const MiniPlayerWidget(),
      body: podcastAsync.when(
        loading: () => const AppLoader(message: 'Loading podcast...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(podcastDetailsProvider(id)),
        ),
        data: (podcast) => SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomNetworkImage(
                      imageUrl: podcast.coverImage,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            podcast.category.toUpperCase(),
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          podcast.title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hosted by ${podcast.host}',
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                podcast.description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const Divider(height: 32, color: AppColors.borderDark),
              Text(
                'Episodes (${podcast.episodes.length})',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
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
