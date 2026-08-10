import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/events_repository.dart';
import '../models/event_model.dart';

final eventsRepositoryProvider = Provider((ref) => EventsRepository());

final eventsListProvider = FutureProvider<List<EventModel>>((ref) async {
  return await ref.watch(eventsRepositoryProvider).getEvents();
});

final eventDetailsProvider = FutureProvider.family<EventModel, String>((ref, id) async {
  return await ref.watch(eventsRepositoryProvider).getEventById(id);
});
