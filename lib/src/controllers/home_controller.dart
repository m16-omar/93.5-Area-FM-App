import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/home_repository.dart';
import '../models/home_model.dart';

final homeRepositoryProvider = Provider((ref) => HomeRepository());

final homeDataFutureProvider = FutureProvider<HomeModel>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  final liveStream = await repo.getLiveStream();
  final shows = await repo.getFeaturedShows();
  final news = await repo.getLatestNews();
  final podcasts = await repo.getFeaturedPodcasts();
  final events = await repo.getUpcomingEvents();

  return HomeModel(
    liveStream: liveStream,
    featuredShows: shows,
    latestNews: news,
    featuredPodcasts: podcasts,
    upcomingEvents: events,
  );
});
