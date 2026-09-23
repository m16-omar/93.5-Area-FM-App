import '../models/post_model.dart';
import '../services/api_service.dart';
import '../../const/api_constants.dart';

class BlogRepository {
  final ApiService _apiService = ApiService();

  static const List<PostModel> _fallbackNews = [
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
          return data
              .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (_) {
      // Fall back seamlessly to local news database
    }
    return _fallbackNews;
  }

  Future<PostModel> getPostById(String id) async {
    try {
      final response = await _apiService.get('${ApiConstants.newsEndpoint}/$id/');
      if (response.statusCode == 200 && response.data != null) {
        return PostModel.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (_) {}

    final posts = await getPosts();
    return posts.firstWhere((p) => p.id == id, orElse: () => posts.first);
  }
}
