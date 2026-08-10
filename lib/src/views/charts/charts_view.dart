import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/charts_provider.dart';
import '../../providers/radio_player_provider.dart';
import '../../models/radio_stream_model.dart';
import 'widgets/chart_item.dart';

class ChartsView extends ConsumerWidget {
  const ChartsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsAsync = ref.watch(topChartsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Top 10 Music Charts'),
      body: chartsAsync.when(
        loading: () => const AppLoader(message: 'Loading charts...'),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (charts) => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: charts.length,
          itemBuilder: (context, index) {
            final track = charts[index];
            return ChartItemWidget(
              track: track,
              onPlay: () {
                final radioStream = RadioStreamModel(
                  id: 'chart_${track.rank}',
                  title: track.title,
                  artist: track.artist,
                  showName: 'Top Chart #${track.rank}',
                  coverUrl: track.albumCover,
                  streamUrl: track.audioUrl,
                  isLive: false,
                );
                ref.read(audioPlayerServiceProvider).playTrack(radioStream);
              },
            );
          },
        ),
      ),
    );
  }
}
