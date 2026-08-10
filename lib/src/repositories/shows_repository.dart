import '../models/show_model.dart';
import '../models/schedule_model.dart';

class ShowsRepository {
  Future<List<ShowModel>> getShows() async {
    return const [
      ShowModel(
        id: 'show1',
        title: 'Morning Drive & Hype',
        presenter: 'DJ Big Shaq',
        airTime: '06:00 AM - 10:00 AM',
        days: 'Mon - Fri',
        image: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
        description: 'Start your day with high energy music, morning traffic updates, and hot topics.',
        genre: 'Entertainment & Hype',
      ),
      ShowModel(
        id: 'show2',
        title: 'Midday Cruise & Vibes',
        presenter: 'Sarah Jenkins',
        airTime: '10:00 AM - 02:00 PM',
        days: 'Mon - Fri',
        image: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=600&q=80',
        description: 'Smooth tunes, listener requests, celebrity gossip, and workplace lounge vibes.',
        genre: 'R&B & Afrobeats',
      ),
      ShowModel(
        id: 'show3',
        title: 'The Evening Drive Rush',
        presenter: 'MC Sparkle',
        airTime: '04:00 PM - 08:00 PM',
        days: 'Mon - Fri',
        image: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
        description: 'Unwind on your commute home with club bangers, sports banter, and live listener call-ins.',
        genre: 'Urban & Hip-Hop',
      ),
    ];
  }

  Future<List<ScheduleModel>> getSchedules() async {
    return const [
      ScheduleModel(
        id: 'sch1',
        day: 'Monday',
        showTitle: 'Morning Drive & Hype',
        presenter: 'DJ Big Shaq',
        startTime: '06:00 AM',
        endTime: '10:00 AM',
        isLiveNow: true,
      ),
      ScheduleModel(
        id: 'sch2',
        day: 'Monday',
        showTitle: 'Midday Cruise & Vibes',
        presenter: 'Sarah Jenkins',
        startTime: '10:00 AM',
        endTime: '02:00 PM',
      ),
      ScheduleModel(
        id: 'sch3',
        day: 'Monday',
        showTitle: 'The Evening Drive Rush',
        presenter: 'MC Sparkle',
        startTime: '04:00 PM',
        endTime: '08:00 PM',
      ),
    ];
  }

  Future<ShowModel> getShowById(String id) async {
    final shows = await getShows();
    return shows.firstWhere((s) => s.id == id, orElse: () => shows.first);
  }
}
