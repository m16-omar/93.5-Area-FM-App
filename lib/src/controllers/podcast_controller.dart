import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/podcast_repository.dart';
import '../models/podcast_model.dart';

final podcastRepositoryProvider = Provider((ref) => PodcastRepository());

final podcastsListProvider = FutureProvider<List<PodcastModel>>((ref) async {
  return await ref.watch(podcastRepositoryProvider).getPodcasts();
});

final podcastDetailsProvider = FutureProvider.family<PodcastModel, String>((ref, id) async {
  return await ref.watch(podcastRepositoryProvider).getPodcastById(id);
});
