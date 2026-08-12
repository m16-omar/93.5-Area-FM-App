import '../models/show_model.dart';
import '../models/post_model.dart';
import '../models/podcast_model.dart';
import '../models/event_model.dart';
import '../models/radio_stream_model.dart';
import '../../const/app_assets.dart';

class HomeRepository {
  Future<RadioStreamModel> getLiveStream() async {
    return const RadioStreamModel(
      id: 'live_main',
      title: 'The Morning Hype Show',
      artist: 'DJ Big Shaq & MC Sparkle',
      showName: '93.5 Area FM Live',
      coverUrl: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
      streamUrl: 'https://stream.zeno.fm/f3wvbbqmdg8uv',
      isLive: true,
    );
  }

  Future<List<ShowModel>> getFeaturedShows() async {
    return const [
      ShowModel(
        id: 'show1',
        title: 'Morning Drive & Hype',
        presenter: 'DJ Big Shaq',
        airTime: '06:00 AM - 10:00 AM',
        days: 'Mon - Fri',
        image: AppAssets.show1,
        description: 'Start your day with high energy music, morning traffic updates, and hot topics.',
        genre: 'Entertainment & Hype',
      ),
      ShowModel(
        id: 'show2',
        title: 'Midday Cruise & Vibes',
        presenter: 'Sarah Jenkins',
        airTime: '10:00 AM - 02:00 PM',
        days: 'Mon - Fri',
        image: AppAssets.show2,
        description: 'Smooth tunes, listener requests, celebrity gossip, and workplace lounge vibes.',
        genre: 'R&B & Afrobeats',
      ),
      ShowModel(
        id: 'show3',
        title: 'The Evening Drive Rush',
        presenter: 'MC Sparkle',
        airTime: '04:00 PM - 08:00 PM',
        days: 'Mon - Fri',
        image: AppAssets.show3,
        description: 'Unwind on your commute home with club bangers, sports banter, and live listener call-ins.',
        genre: 'Urban & Hip-Hop',
      ),
    ];
  }

  Future<List<PostModel>> getLatestNews() async {
    return const [
      PostModel(
        id: 'news1',
        title: '93.5 Area FM Launches New Studio & High Definition Live Stream',
        category: 'Station News',
        author: 'Editorial Team',
        date: 'July 30, 2026',
        image: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
        summary: 'Upgraded broadcast acoustics and crystal-clear mobile streaming for listeners worldwide.',
        content: '93.5 Area FM has officially unveiled its next-generation digital broadcast facility.',
        tags: ['Radio', 'HD Audio'],
      ),
      PostModel(
        id: 'news2',
        title: 'Annual City Music Festival Announced featuring Top Headliners',
        category: 'Events',
        author: 'Entertainment Desk',
        date: 'July 27, 2026',
        image: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
        summary: 'Get ready for the biggest urban music event of the year powered by 93.5 Area FM.',
        content: 'The annual City Music Festival returns this August with over 30 artists performing live.',
        tags: ['Concert', 'Live Music'],
      ),
    ];
  }

  Future<List<PodcastModel>> getFeaturedPodcasts() async {
    return const [
      PodcastModel(
        id: 'pod1',
        title: 'The Fan Zone #1',
        showName: 'Sports Extra',
        host: 'Alex Rivera',
        category: 'Sports & Talk',
        coverImage: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=600&q=80',
        description: 'Deep dive into weekend league matches, player interviews, and match tactical breakdowns.',
        episodesCount: 12,
      ),
      PodcastModel(
        id: 'pod2',
        title: 'Tech & Tomorrow',
        showName: 'Future Tech',
        host: 'Elena Vance',
        category: 'Technology',
        coverImage: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=600&q=80',
        description: 'Exploring AI innovations, mobile ecosystems, and the digital economy.',
        episodesCount: 8,
      ),
    ];
  }

  Future<List<EventModel>> getUpcomingEvents() async {
    return const [
      EventModel(
        id: 'evt1',
        title: '93.5 Area FM Summer Beach Rave',
        date: 'August 24, 2026',
        time: '04:00 PM WAT',
        location: 'Victoria Beach Arena, Lagos',
        bannerImage: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
        description: 'The biggest outdoor music festival with top DJs and live performances.',
      ),
    ];
  }
}
