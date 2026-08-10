import '../models/event_model.dart';

class EventsRepository {
  Future<List<EventModel>> getEvents() async {
    return const [
      EventModel(
        id: 'evt1',
        title: '93.5 Area FM Summer Beach Rave',
        date: 'August 24, 2026',
        time: '04:00 PM WAT',
        location: 'Victoria Beach Arena, Lagos',
        bannerImage: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
        description: 'The biggest outdoor music festival with top DJs, live band performances, celebrity hosts, and food stalls.',
        ticketUrl: 'https://area935fm.com/tickets/rave',
      ),
      EventModel(
        id: 'evt2',
        title: 'Urban Comedy Night Live',
        date: 'September 05, 2026',
        time: '07:00 PM WAT',
        location: 'Grand Ballroom Hotel, Lagos',
        bannerImage: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80',
        description: 'An evening of non-stop laughter featuring top stand-up comedians hosted by MC Sparkle.',
        ticketUrl: 'https://area935fm.com/tickets/comedy',
      ),
    ];
  }

  Future<EventModel> getEventById(String id) async {
    final events = await getEvents();
    return events.firstWhere((e) => e.id == id, orElse: () => events.first);
  }
}
