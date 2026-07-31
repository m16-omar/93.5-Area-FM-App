import '../models/track_model.dart';
import '../models/schedule_model.dart';
import '../models/podcast_model.dart';
import '../models/news_model.dart';
import '../models/chart_model.dart';

class DataRepository {
  static const TrackModel liveStreamTrack = TrackModel(
    id: 'live_935',
    title: 'Morning Vibe Blast',
    artist: 'Jordan Carter & DJ Spark',
    showName: 'Morning Vibe Blast',
    presenterName: 'Jordan Carter',
    image: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80',
    audioUrl: 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=lofi-study-112191.mp3',
    isLiveStream: true,
    genre: 'Urban & Afrobeats',
  );

  static final List<ScheduleItem> scheduleItems = [
    const ScheduleItem(
      id: 'sch1',
      showTitle: 'Morning Vibe Blast',
      presenter: 'Jordan Carter',
      day: 'Monday',
      timeSlot: '06:00 AM - 10:00 AM',
      image: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80',
      genre: 'Afrobeats & Talk',
      description: 'Kickstart your morning with high-energy tunes, local news highlights, and live listener interaction.',
      isLiveNow: true,
    ),
    const ScheduleItem(
      id: 'sch2',
      showTitle: 'The Midday Groove',
      presenter: 'DJ Spark & Sarah Jenkins',
      day: 'Monday',
      timeSlot: '10:00 AM - 02:00 PM',
      image: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
      genre: 'Top 40 Hits',
      description: 'Smooth midday transitions, trending celebrity gossip, and non-stop hit music.',
    ),
    const ScheduleItem(
      id: 'sch3',
      showTitle: 'Area Drive Time',
      presenter: 'Marcus Vibe',
      day: 'Monday',
      timeSlot: '02:00 PM - 06:00 PM',
      image: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
      genre: 'Hip Hop & RnB',
      description: 'Beat traffic with the hottest drive-time countdown and live traffic updates.',
    ),
    const ScheduleItem(
      id: 'sch4',
      showTitle: 'Night Moods & Slow Jams',
      presenter: 'Vanessa Cole',
      day: 'Monday',
      timeSlot: '06:00 PM - 11:00 PM',
      image: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=600&q=80',
      genre: 'Slow Jams & Soul',
      description: 'Unwind your evening with soulful melodies, love notes, and late-night requests.',
    ),
  ];

  static final List<PodcastModel> podcasts = [
    const PodcastModel(
      id: 'pod1',
      title: 'The Fan Zone #1',
      showName: 'Sports Extra',
      host: 'Alex Rivera',
      category: 'Sports & Talk',
      coverImage: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=600&q=80',
      description: 'Deep dive into weekend league matches, player interviews, and match tactical breakdowns.',
      episodesCount: 12,
      episodes: [
        EpisodeModel(
          id: 'ep101',
          title: 'Season Preview & Derby Breakdown',
          duration: '42 min',
          publishDate: 'July 28, 2026',
          audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/15/audio_c8c8a6a43e.mp3?filename=funky-synthwave-111668.mp3',
          description: 'Analyzing team transfers, tactical formations, and derby predictions.',
        ),
        EpisodeModel(
          id: 'ep102',
          title: 'Exclusive Interview with Top Striker',
          duration: '35 min',
          publishDate: 'July 21, 2026',
          audioUrl: 'https://cdn.pixabay.com/download/audio/2022/01/18/audio_d0a13f69d2.mp3?filename=tropical-house-11524.mp3',
          description: 'Behind the scenes story of championship dreams and personal journey.',
        ),
      ],
    ),
    const PodcastModel(
      id: 'pod2',
      title: 'Tech & Tomorrow',
      showName: 'Future Tech',
      host: 'Elena Vance',
      category: 'Technology',
      coverImage: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=600&q=80',
      description: 'Exploring AI innovations, mobile ecosystems, and the digital economy.',
      episodesCount: 8,
      episodes: [
        EpisodeModel(
          id: 'ep201',
          title: 'Generative AI & Mobile Apps',
          duration: '28 min',
          publishDate: 'July 29, 2026',
          audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/10/audio_c8c8a6a43e.mp3?filename=synthwave-111668.mp3',
          description: 'How AI-driven tools are reshaping mobile UX and interactive broadcast radio.',
        ),
      ],
    ),
  ];

  static final List<ChartTrackModel> topCharts = [
    const ChartTrackModel(
      rank: 1,
      title: 'City Lights',
      artist: 'K-Star ft. Luna',
      albumCover: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=300&q=80',
      votes: 14250,
      audioUrl: 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=lofi-study-112191.mp3',
      peakPosition: '#1 for 3 weeks',
    ),
    const ChartTrackModel(
      rank: 2,
      title: 'Midnight Drive',
      artist: 'Metro Groove',
      albumCover: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=format&fit=crop&w=300&q=80',
      votes: 12890,
      audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/15/audio_c8c8a6a43e.mp3?filename=funky-synthwave-111668.mp3',
      peakPosition: '#2',
    ),
    const ChartTrackModel(
      rank: 3,
      title: 'Afro Rhythm',
      artist: 'DJ Bazz',
      albumCover: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=300&q=80',
      votes: 11400,
      audioUrl: 'https://cdn.pixabay.com/download/audio/2022/01/18/audio_d0a13f69d2.mp3?filename=tropical-house-11524.mp3',
      peakPosition: '#1',
    ),
  ];

  static final List<NewsModel> newsList = [
    const NewsModel(
      id: 'news1',
      title: '93.5 Area FM Launches New Studio & High Definition Live Stream',
      category: 'Station News',
      author: 'Editorial Team',
      date: 'July 30, 2026',
      image: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
      summary: 'Upgraded broadcast acoustics and crystal-clear mobile streaming for listeners worldwide.',
      content: '93.5 Area FM has officially unveiled its next-generation digital broadcast facility with state-of-the-art acoustics and ultra-low latency mobile streaming capabilities. Listeners can now enjoy crystal-clear audio quality on iOS, Android, and web platforms.',
      tags: ['Radio', 'HD Audio', 'Station Upgrade'],
    ),
    const NewsModel(
      id: 'news2',
      title: 'Annual City Music Festival Announced featuring Top Headliners',
      category: 'Events',
      author: 'Entertainment Desk',
      date: 'July 27, 2026',
      image: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
      summary: 'Get ready for the biggest urban music event of the year powered by 93.5 Area FM.',
      content: 'The annual City Music Festival returns this August with over 30 artists performing live across three stages. Early bird tickets and VIP passes are now available exclusively through 93.5 Area FM mobile app.',
      tags: ['Concert', 'Live Music', 'Festival'],
    ),
  ];
}
