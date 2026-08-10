import 'show_model.dart';
import 'post_model.dart';
import 'podcast_model.dart';
import 'event_model.dart';
import 'radio_stream_model.dart';

class HomeModel {
  final RadioStreamModel liveStream;
  final List<ShowModel> featuredShows;
  final List<PostModel> latestNews;
  final List<PodcastModel> featuredPodcasts;
  final List<EventModel> upcomingEvents;

  const HomeModel({
    required this.liveStream,
    required this.featuredShows,
    required this.latestNews,
    required this.featuredPodcasts,
    required this.upcomingEvents,
  });
}
