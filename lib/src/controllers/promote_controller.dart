import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/promote_repository.dart';
import '../models/promotion_model.dart';

final promoteRepositoryProvider = Provider((ref) => PromoteRepository());

final promotionPackagesProvider = FutureProvider<List<PromotionModel>>((ref) async {
  return await ref.watch(promoteRepositoryProvider).getPackages();
});
