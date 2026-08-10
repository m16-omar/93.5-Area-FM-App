import '../models/post_model.dart';

class BlogRepository {
  Future<List<PostModel>> getPosts() async {
    return const [
      PostModel(
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
      PostModel(
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
      PostModel(
        id: 'news3',
        title: 'Behind the Mic: Interview with DJ Big Shaq',
        category: 'Interviews',
        author: 'Sarah Jenkins',
        date: 'July 20, 2026',
        image: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80',
        summary: 'DJ Big Shaq shares insights into his 10-year radio journey and upcoming music projects.',
        content: 'In this exclusive interview, DJ Big Shaq discusses how radio culture has evolved and what keeps him inspired every morning.',
        tags: ['Interview', 'DJ Big Shaq', 'Radio Culture'],
      ),
    ];
  }

  Future<PostModel> getPostById(String id) async {
    final posts = await getPosts();
    return posts.firstWhere((p) => p.id == id, orElse: () => posts.first);
  }
}
