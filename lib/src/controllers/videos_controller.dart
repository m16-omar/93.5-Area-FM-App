import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/videos_repository.dart';
import '../models/video_model.dart';

final videosRepositoryProvider = Provider((ref) => VideosRepository());

final videosListProvider = FutureProvider<List<VideoModel>>((ref) async {
  return await ref.watch(videosRepositoryProvider).getVideos();
});

final videoDetailsProvider = FutureProvider.family<VideoModel, String>((ref, id) async {
  return await ref.watch(videosRepositoryProvider).getVideoById(id);
});
