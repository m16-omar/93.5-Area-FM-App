import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/presenter_repository.dart';
import '../models/presenter_model.dart';

final presenterRepositoryProvider = Provider((ref) => PresenterRepository());

final presentersListProvider = FutureProvider<List<PresenterModel>>((ref) async {
  return await ref.watch(presenterRepositoryProvider).getPresenters();
});

final presenterDetailsProvider = FutureProvider.family<PresenterModel, String>((ref, id) async {
  return await ref.watch(presenterRepositoryProvider).getPresenterById(id);
});
