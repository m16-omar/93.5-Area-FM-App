import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/helpers/url_helper.dart';
import '../../providers/videos_provider.dart';
import 'widgets/video_player.dart';

class VideoDetailsView extends ConsumerWidget {
  final String id;

  const VideoDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(videoDetailsProvider(id));

    return Scaffold(
      appBar: const CustomAppBar(title: 'Watch Video'),
      body: videoAsync.when(
        loading: () => const AppLoader(),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (video) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoPlayerWidget(
                thumbnailUrl: video.thumbnailUrl,
                onPlay: () => UrlHelper.launchURL(video.videoUrl),
              ),
              const SizedBox(height: 16),
              Text(
                video.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                '${video.views} views • ${video.publishDate}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Divider(height: 32),
              Text(
                video.description,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
