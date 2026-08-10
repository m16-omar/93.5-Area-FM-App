import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/radio_repository.dart';
import '../models/radio_stream_model.dart';

final radioRepositoryProvider = Provider((ref) => RadioRepository());

final liveStreamDetailsProvider = FutureProvider<RadioStreamModel>((ref) async {
  return await ref.watch(radioRepositoryProvider).getLiveStreamDetails();
});
