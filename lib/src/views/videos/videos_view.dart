import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/videos_provider.dart';
import 'widgets/video_card.dart';

class VideosView extends ConsumerWidget {
  const VideosView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(videosListProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Studio Videos & Interviews'),
      body: videosAsync.when(
        loading: () => const AppLoader(message: 'Loading videos...'),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (videos) => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: videos.length,
          itemBuilder: (context, index) => VideoCardWidget(
            video: videos[index],
            onTap: () => context.push('/video_details/${videos[index].id}'),
          ),
        ),
      ),
    );
  }
}
