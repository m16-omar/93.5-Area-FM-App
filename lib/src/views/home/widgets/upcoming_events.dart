import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/components/section_header.dart';
import '../../../../common/components/event_card.dart';
import '../../../models/event_model.dart';

class UpcomingEventsWidget extends StatelessWidget {
  final List<EventModel> events;

  const UpcomingEventsWidget({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Upcoming Station Events',
          actionText: 'View All',
          onActionTap: () => context.push('/events'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (context, index) => EventCard(
              event: events[index],
              onTap: () => context.push('/event_details/${events[index].id}'),
            ),
          ),
        ),
      ],
    );
  }
}
