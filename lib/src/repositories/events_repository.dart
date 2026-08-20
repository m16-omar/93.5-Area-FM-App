import '../models/event_model.dart';

class EventsRepository {
  Future<List<EventModel>> getEvents() async {
    return const [
      // Upcoming Events
      EventModel(
        id: 'evt1',
        title: 'AREA Concert 2024',
        date: 'May 25, 2024',
        month: 'MAY',
        day: '25',
        weekday: 'SAT',
        time: '6:00 PM',
        location: 'Eko Convention Centre, Lagos',
        bannerImage: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=600&q=80',
        description: 'The biggest music concert in the city is back! Live performances from top artists.',
        ticketUrl: 'https://935areafm.com/tickets/concert2024',
        isUpcoming: true,
      ),
      EventModel(
        id: 'evt2',
        title: 'Night Vibes with DJ Ace',
        date: 'May 31, 2024',
        month: 'MAY',
        day: '31',
        weekday: 'FRI',
        time: '9:00 PM',
        location: 'Club Quilox, Victoria Island',
        bannerImage: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?auto=format&fit=crop&w=600&q=80',
        description: 'An unforgettable night of music, dance and good vibes with DJ Ace and friends.',
        ticketUrl: 'https://935areafm.com/tickets/nightvibes',
        isUpcoming: true,
      ),
      EventModel(
        id: 'evt3',
        title: 'Community Outreach 2024',
        date: 'June 08, 2024',
        month: 'JUN',
        day: '08',
        weekday: 'SAT',
        time: '10:00 AM',
        location: 'Agege Community Centre, Lagos',
        bannerImage: 'https://images.unsplash.com/photo-1528605248644-14dd04022da1?auto=format&fit=crop&w=600&q=80',
        description: 'Join us as we give back to the community and make a difference together.',
        ticketUrl: 'https://935areafm.com/tickets/outreach',
        isUpcoming: true,
      ),
      // Past Events
      EventModel(
        id: 'evt4',
        title: 'AREA Easter Fiesta',
        date: 'April 20, 2024',
        month: 'APR',
        day: '20',
        weekday: 'SAT',
        time: '4:00 PM',
        location: 'Landmark Beach, Victoria Island',
        bannerImage: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
        description: 'Easter holiday beach festival featuring live Afrobeats DJs and games.',
        isUpcoming: false,
      ),
      EventModel(
        id: 'evt5',
        title: 'Throwback Thursday',
        date: 'April 06, 2024',
        month: 'APR',
        day: '06',
        weekday: 'THU',
        time: '8:00 PM',
        location: 'The Hard Rock Cafe, Lagos',
        bannerImage: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80',
        description: 'Retro 90s & 2000s classics night with special guest vinyl DJs.',
        isUpcoming: false,
      ),
      EventModel(
        id: 'evt6',
        title: "Women's Day Special",
        date: 'March 29, 2024',
        month: 'MAR',
        day: '29',
        weekday: 'FRI',
        time: '5:00 PM',
        location: 'Civic Centre, Victoria Island',
        bannerImage: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=600&q=80',
        description: 'Celebrating extraordinary women in media, arts, and broadcasting.',
        isUpcoming: false,
      ),
      EventModel(
        id: 'evt7',
        title: 'Valentin Special',
        date: 'March 15, 2024',
        month: 'MAR',
        day: '15',
        weekday: 'FRI',
        time: '7:00 PM',
        location: 'Muri Okunola Park, Victoria Island',
        bannerImage: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=600&q=80',
        description: 'Love concert & romantic evening under the stars with live acoustic set.',
        isUpcoming: false,
      ),
    ];
  }

  Future<EventModel> getEventById(String id) async {
    final events = await getEvents();
    return events.firstWhere((e) => e.id == id, orElse: () => events.first);
  }
}
