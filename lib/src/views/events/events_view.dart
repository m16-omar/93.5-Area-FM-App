import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/events_provider.dart';
import 'widgets/event_card.dart';

class EventsView extends ConsumerWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsListProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Station Events & Raves'),
      body: eventsAsync.when(
        loading: () => const AppLoader(message: 'Loading events...'),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (events) => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: events.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: EventCardWidget(
              event: events[index],
              onTap: () => context.push('/event_details/${events[index].id}'),
            ),
          ),
        ),
      ),
    );
  }
}
