import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/shows_repository.dart';
import '../models/show_model.dart';
import '../models/schedule_model.dart';

final showsRepositoryProvider = Provider((ref) => ShowsRepository());

final showsListProvider = FutureProvider<List<ShowModel>>((ref) async {
  return await ref.watch(showsRepositoryProvider).getShows();
});

final schedulesListProvider = FutureProvider<List<ScheduleModel>>((ref) async {
  return await ref.watch(showsRepositoryProvider).getSchedules();
});

final showDetailsProvider = FutureProvider.family<ShowModel, String>((ref, id) async {
  return await ref.watch(showsRepositoryProvider).getShowById(id);
});
