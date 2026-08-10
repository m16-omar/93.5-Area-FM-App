import '../models/presenter_model.dart';

class PresenterRepository {
  Future<List<PresenterModel>> getPresenters() async {
    return const [
      PresenterModel(
        id: 'pres1',
        name: 'DJ Big Shaq',
        showName: 'Morning Drive & Hype',
        image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
        bio: 'Top urban DJ and radio personality host with over a decade of broadcast experience.',
        instagram: 'https://instagram.com/djbigshaq',
        twitter: 'https://twitter.com/djbigshaq',
      ),
      PresenterModel(
        id: 'pres2',
        name: 'Sarah Jenkins',
        showName: 'Midday Cruise & Vibes',
        image: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=600&q=80',
        bio: 'Lover of smooth Afrobeats, celebrity news, and interactive lounge conversations.',
        instagram: 'https://instagram.com/sarahjenkins',
      ),
      PresenterModel(
        id: 'pres3',
        name: 'MC Sparkle',
        showName: 'The Evening Drive Rush',
        image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=600&q=80',
        bio: 'Hype master and evening drive host bringing high energy beat mixes and sports updates.',
        twitter: 'https://twitter.com/mcsparkle',
      ),
    ];
  }

  Future<PresenterModel> getPresenterById(String id) async {
    final presenters = await getPresenters();
    return presenters.firstWhere((p) => p.id == id, orElse: () => presenters.first);
  }
}
