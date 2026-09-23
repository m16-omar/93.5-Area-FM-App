import '../models/post_model.dart';
import '../services/api_service.dart';
import '../../const/api_constants.dart';

class BlogRepository {
  final ApiService _apiService = ApiService();

  static const List<PostModel> _fallbackNews = [
    PostModel(
      id: '82',
      title: 'Funke Akindele Credits Discipline and Sacrifice for ₦2.7bn Box Office Record',
      category: 'Entertainment',
      author: 'Area FM News Desk',
      date: 'Jun 12, 2026',
      image: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80',
      summary: 'Nollywood filmmaker and actress Funke Akindele has opened up about the dedication behind her record-breaking box office success.',
      content: 'Nollywood powerhouse Funke Akindele has credited relentless discipline, creative sacrifice, and an unwavering commitment to audience satisfaction for her unmatched ₦2.7 billion box office milestone.\n\nSpeaking in an exclusive interview, the acclaimed filmmaker shared how meticulous planning, rigorous script development, and trust in her production crew paved the way for monumental success across West African cinemas.\n\n"Every project is approached with passion and perfectionism. We owe our audience nothing less than world-class storytelling," Akindele emphasized.',
      tags: ['Entertainment', 'Nollywood', 'Box Office', 'Funke Akindele'],
    ),
    PostModel(
      id: '81',
      title: 'Niniola Mourns Late Husband, Says \'I Did Nothing Wrong\'',
      category: 'Entertainment',
      author: 'Entertainment Desk',
      date: 'Jun 10, 2026',
      image: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?auto=format&fit=crop&w=600&q=80',
      summary: 'Queen of Afro-House Niniola breaks her silence regarding emotional grief and addressing public speculation.',
      content: 'Grammy-nominated Afro-House diva Niniola has spoken publicly about navigating deep personal loss following the passing of her partner.\n\nIn a heartfelt message shared with fans and media, she reflected on love, resilience, and setting the record straight against baseless online rumors.\n\n"Grief is a deeply personal journey. I stand in my truth and focus on music, healing, and honoring loved ones with grace," she shared.',
      tags: ['Entertainment', 'Music', 'Niniola', 'Afrobeats'],
    ),
    PostModel(
      id: '79',
      title: 'Davido Calls for Mental Health Facilities Dedicated to Entertainers',
      category: 'Entertainment',
      author: 'Area FM News Desk',
      date: 'Jun 05, 2026',
      image: 'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?auto=format&fit=crop&w=600&q=80',
      summary: 'Afrobeats icon Davido advocates for structured mental wellness and counseling centers for African creatives and performers.',
      content: 'Global music sensation Davido has championed the urgent need for dedicated mental wellness and psychological support centers for entertainers.\n\nAddressing industry stakeholders, the superstar highlighted the relentless scrutiny, grueling touring schedules, and emotional toll that performers frequently navigate behind the scenes.\n\n"We need safe spaces, professional support, and open conversations about mental health in our creative ecosystem," Davido urged.',
      tags: ['Entertainment', 'Davido', 'Mental Health', 'Afrobeats'],
    ),
    PostModel(
      id: '55',
      title: 'Burna Boy Breaks Spotify Monthly Listeners Record for an African Artist',
      category: 'Entertainment',
      author: 'Area FM News Desk',
      date: 'May 28, 2026',
      image: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
      summary: 'The Grammy-winning African Giant sets a new global streaming milestone with unprecedented Spotify monthly listener numbers.',
      content: 'Burna Boy has officially shattered the Spotify monthly listener record for an African artist, crossing unprecedented global streaming figures.\n\nDriven by worldwide sold-out stadium tours and charting collaborations, the international superstar continues to elevate African music onto the world’s biggest stages.',
      tags: ['Entertainment', 'Burna Boy', 'Spotify', 'Record Breaker'],
    ),
    PostModel(
      id: '4',
      title: '“Prove me wrong that Tinubu won’t be running against himself in 2027” — Barr. Ozekhome challenges Nigerians',
      category: 'Politics',
      author: 'Mike Ozekhome (SAN)',
      date: 'Apr 29, 2026',
      image: 'https://res.cloudinary.com/dgjzsen3g/image/upload/media/news/1_qgonoh',
      summary: 'A Senior Advocate of Nigeria (SAN), Mike Ozekhome, has stirred fresh debate over the credibility of Nigeria’s electoral process ahead of the 2027 general elections.',
      content: 'A Senior Advocate of Nigeria (SAN), Mike Ozekhome, has stirred fresh debate over the credibility of Nigeria’s electoral process ahead of the 2027 general elections.\n\nIn a viral video circulating on social media, the legal practitioner openly questioned the fairness of the upcoming polls, urging citizens to take action and prove him wrong.\n\nOzekhome stated, “I want to challenge Nigerians to do something to prove me wrong that Tinubu will not be running against himself in 2027.”\n\nGrowing Concerns About Electoral Integrity:\nThe comment has reignited conversations about trust in Nigeria’s democratic system and the perceived imbalance in the political space.\n\nMany Nigerians interpret his statement as a warning that the electoral process may not be competitive, particularly with Bola Ahmed Tinubu expected to seek re-election.\n\nPublic Reactions Reflect Mixed Sentiments:\nFollowing the video’s circulation, Nigerians took to social media to express a mix of frustration, resignation, and scepticism.',
      tags: ['Politics', 'Election 2027', 'Ozekhome', 'Nigeria'],
    ),
    PostModel(
      id: '3',
      title: '”About 12 years” – Apostle Johnson Suleman shares how he got his first plane',
      category: 'Entertainment',
      author: 'Area FM News Desk',
      date: 'Apr 29, 2026',
      image: 'https://res.cloudinary.com/dgjzsen3g/image/upload/media/news/Apostle_ebqvvx',
      summary: 'According to him, he placed a couple on a monthly salary for twelve years, paying the husband ₦100,000 and the wife ₦50,000 before receiving a surprise private jet gift.',
      content: 'Apostle Johnson Suleman shared the incredible story of how he received his first aircraft.\n\nAccording to him, he placed a couple on a monthly salary for twelve years, paying the husband ₦100,000 and the wife ₦50,000.\n\nHowever, after 4 years, the man ventured into oil and gas.\n\nSpeaking further, the prominent clergyman disclosed that he was unaware, but continued paying him monthly.\n\nJohnson Suleman Surprised With Private Jet:\nRecounting the unexpected surprise gift, the clergyman disclosed that he was directed to visit an airport minutes after arriving in Lagos.\n\nUpon arrival at the airport, he saw a plane, which turned out to be his, making him a first-time aircraft owner.\n\n“I was driving to the airport, he called me. Few minutes after that time, I got to Lagos. They said just go to a particular airport and check something. I went there, it was a plane, that’s how I own my first jet”, he added.',
      tags: ['Entertainment', 'Apostle Suleman', 'Lifestyle', 'News'],
    ),
    PostModel(
      id: '2',
      title: 'Omah Lay is only Nigerian artiste I can have one-night stand with – Phyna',
      category: 'Music',
      author: 'Entertainment Desk',
      date: 'Apr 29, 2026',
      image: 'https://res.cloudinary.com/dgjzsen3g/image/upload/media/news/Omah_Lay_eizghq',
      summary: 'BBNaija star Phyna reveals that Afropop star Omah Lay is the only Nigerian musician she has a deep connection with.',
      content: 'BBNaija star, Phyna opines that Omah Lay is the only Nigerian musician she can have a one-night stand with.\n\nThe reality star made this known while speaking during a recent livestream.\n\nAccording to her, the reality star, who was asked which artiste she could have a connection with, named the Afropop artist, Omah Lay:\n\n“Actually, a Nigerian artiste that I can have one night with is Omah Lay. I low-key like Omah Lay ooo.”\n\nReactions have followed swiftly across social media platforms with fans discussing her viral livestream remarks.',
      tags: ['Music', 'Phyna', 'Omah Lay', 'Afrobeats', 'Celebrity'],
    ),
  ];

  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _apiService.get(ApiConstants.newsEndpoint);
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['results'] is List ? response.data['results'] : []);
        if (data.isNotEmpty) {
          final list = data
              .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
              .toList();
          list.sort((a, b) {
            final idA = int.tryParse(a.id) ?? 0;
            final idB = int.tryParse(b.id) ?? 0;
            return idB.compareTo(idA);
          });
          return list;
        }
      }
    } catch (_) {
      // Fall back seamlessly to local news database
    }
    return _fallbackNews;
  }

  Future<PostModel> getPostById(String id) async {
    try {
      final response = await _apiService.get('${ApiConstants.newsEndpoint}$id/');
      if (response.statusCode == 200 && response.data != null) {
        return PostModel.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (_) {}

    final posts = await getPosts();
    return posts.firstWhere((p) => p.id == id, orElse: () => posts.first);
  }

  static const List<String> defaultCategories = [
    'All',
    'Entertainment',
    'Music',
    'Sport',
    'Politics',
    'Business',
  ];

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.newsCategoriesEndpoint);
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data['results'] is List ? response.data['results'] : []);
        if (data.isNotEmpty) {
          final sortedData = List<Map<String, dynamic>>.from(
            data.whereType<Map<String, dynamic>>(),
          )..sort((a, b) {
              final idA = int.tryParse(a['id']?.toString() ?? '0') ?? 0;
              final idB = int.tryParse(b['id']?.toString() ?? '0') ?? 0;
              return idB.compareTo(idA);
            });

          final cats = sortedData
              .map((item) => (item['name'] ?? '').toString().trim())
              .where((s) => s.isNotEmpty)
              .toSet()
              .toList();
          return ['All', ...cats];
        }
      }
    } catch (_) {}

    return defaultCategories;
  }
}
