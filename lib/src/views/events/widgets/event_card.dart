import 'package:flutter/material.dart';
import '../../../../common/components/event_card.dart';
import '../../../models/event_model.dart';

class EventCardWidget extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventCardWidget({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return EventCard(event: event, onTap: onTap);
  }
}
