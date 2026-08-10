import '../models/promotion_model.dart';

class PromoteRepository {
  Future<List<PromotionModel>> getPackages() async {
    return const [
      PromotionModel(
        id: 'p1',
        title: 'Basic Advert Jingle',
        description: 'Ideal for small businesses looking for quick brand exposure.',
        packageType: 'Jingle Spot',
        price: 150000.0,
        features: ['30-sec radio jingle', '10 slots per week', 'Social media mention'],
      ),
      PromotionModel(
        id: 'p2',
        title: 'Prime Time Show Sponsor',
        description: 'Exclusive sponsorship of Morning Drive or Evening Rush.',
        packageType: 'Sponsorship',
        price: 500000.0,
        features: ['Full show naming rights', '60-sec live presenter read', 'Banner placement in mobile app'],
      ),
    ];
  }

  Future<bool> submitPromotionForm(Map<String, dynamic> formData) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
