import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/show_model.dart';
import '../models/podcast_model.dart';
import '../models/post_model.dart';
import '../models/event_model.dart';
import '../models/presenter_model.dart';
import '../models/video_model.dart';
import '../repositories/shows_repository.dart';
import '../repositories/podcast_repository.dart';
import '../repositories/blog_repository.dart';
import '../repositories/events_repository.dart';
import '../repositories/presenter_repository.dart';
import '../repositories/videos_repository.dart';

enum SearchCategory {
  all,
  shows,
  podcasts,
  news,
  events,
  presenters,
  videos,
}

class SearchResultState {
  final String query;
  final SearchCategory selectedCategory;
  final bool isLoading;
  final List<String> recentSearches;
  final List<ShowModel> shows;
  final List<PodcastModel> podcasts;
  final List<PostModel> posts;
  final List<EventModel> events;
  final List<PresenterModel> presenters;
  final List<VideoModel> videos;

  const SearchResultState({
    this.query = '',
    this.selectedCategory = SearchCategory.all,
    this.isLoading = false,
    this.recentSearches = const [
      'Morning Drive',
      'Afrobeats',
      'DJ Tobi',
      'Area Concert 2024',
      'Lagos Metro',
    ],
    this.shows = const [],
    this.podcasts = const [],
    this.posts = const [],
    this.events = const [],
    this.presenters = const [],
    this.videos = const [],
  });

  int get totalResultsCount =>
      shows.length +
      podcasts.length +
      posts.length +
      events.length +
      presenters.length +
      videos.length;

  bool get isEmpty =>
      query.trim().isNotEmpty && !isLoading && totalResultsCount == 0;

  SearchResultState copyWith({
    String? query,
    SearchCategory? selectedCategory,
    bool? isLoading,
    List<String>? recentSearches,
    List<ShowModel>? shows,
    List<PodcastModel>? podcasts,
    List<PostModel>? posts,
    List<EventModel>? events,
    List<PresenterModel>? presenters,
    List<VideoModel>? videos,
  }) {
    return SearchResultState(
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      recentSearches: recentSearches ?? this.recentSearches,
      shows: shows ?? this.shows,
      podcasts: podcasts ?? this.podcasts,
      posts: posts ?? this.posts,
      events: events ?? this.events,
      presenters: presenters ?? this.presenters,
      videos: videos ?? this.videos,
    );
  }
}

class GlobalSearchNotifier extends Notifier<SearchResultState> {
  final ShowsRepository _showsRepo = ShowsRepository();
  final PodcastRepository _podcastRepo = PodcastRepository();
  final BlogRepository _blogRepo = BlogRepository();
  final EventsRepository _eventsRepo = EventsRepository();
  final PresenterRepository _presenterRepo = PresenterRepository();
  final VideosRepository _videosRepo = VideosRepository();

  List<ShowModel> _allShows = [];
  List<PodcastModel> _allPodcasts = [];
  List<PostModel> _allPosts = [];
  List<EventModel> _allEvents = [];
  List<PresenterModel> _allPresenters = [];
  List<VideoModel> _allVideos = [];

  @override
  SearchResultState build() {
    _preloadData();
    return const SearchResultState();
  }

  Future<void> _preloadData() async {
    try {
      final results = await Future.wait([
        _showsRepo.getShows(),
        _podcastRepo.getPodcasts(),
        _blogRepo.getPosts(),
        _eventsRepo.getEvents(),
        _presenterRepo.getPresenters(),
        _videosRepo.getVideos(),
      ]);

      _allShows = results[0] as List<ShowModel>;
      _allPodcasts = results[1] as List<PodcastModel>;
      _allPosts = results[2] as List<PostModel>;
      _allEvents = results[3] as List<EventModel>;
      _allPresenters = results[4] as List<PresenterModel>;
      _allVideos = results[5] as List<VideoModel>;
    } catch (_) {}
  }

  void setCategory(SearchCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void addRecentSearch(String term) {
    final clean = term.trim();
    if (clean.isEmpty) return;
    final updated = List<String>.from(state.recentSearches);
    updated.remove(clean);
    updated.insert(0, clean);
    if (updated.length > 8) updated.removeLast();
    state = state.copyWith(recentSearches: updated);
  }

  void removeRecentSearch(String term) {
    final updated = List<String>.from(state.recentSearches)..remove(term);
    state = state.copyWith(recentSearches: updated);
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: const []);
  }

  void search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      state = state.copyWith(
        query: '',
        shows: const [],
        podcasts: const [],
        posts: const [],
        events: const [],
        presenters: const [],
        videos: const [],
      );
      return;
    }

    final matchedShows = _allShows.where((s) {
      return s.title.toLowerCase().contains(q) ||
          s.presenter.toLowerCase().contains(q) ||
          s.genre.toLowerCase().contains(q) ||
          s.description.toLowerCase().contains(q);
    }).toList();

    final matchedPodcasts = _allPodcasts.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.showName.toLowerCase().contains(q) ||
          p.host.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();

    final matchedPosts = _allPosts.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.author.toLowerCase().contains(q) ||
          p.summary.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();

    final matchedEvents = _allEvents.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.location.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q);
    }).toList();

    final matchedPresenters = _allPresenters.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.showName.toLowerCase().contains(q) ||
          p.bio.toLowerCase().contains(q);
    }).toList();

    final matchedVideos = _allVideos.where((v) {
      return v.title.toLowerCase().contains(q) ||
          v.description.toLowerCase().contains(q);
    }).toList();

    state = state.copyWith(
      query: query,
      shows: matchedShows,
      podcasts: matchedPodcasts,
      posts: matchedPosts,
      events: matchedEvents,
      presenters: matchedPresenters,
      videos: matchedVideos,
    );
  }

  void clearSearch() {
    state = state.copyWith(
      query: '',
      shows: const [],
      podcasts: const [],
      posts: const [],
      events: const [],
      presenters: const [],
      videos: const [],
    );
  }
}

final globalSearchProvider =
    NotifierProvider<GlobalSearchNotifier, SearchResultState>(
  GlobalSearchNotifier.new,
);
