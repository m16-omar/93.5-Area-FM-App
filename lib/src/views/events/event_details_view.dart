import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/helpers/url_helper.dart';
import '../../providers/events_provider.dart';
import 'widgets/event_banner.dart';

class EventDetailsView extends ConsumerWidget {
  final String id;

  const EventDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailsProvider(id));

    return Scaffold(
      appBar: const CustomAppBar(title: 'Event Details'),
      body: eventAsync.when(
        loading: () => const AppLoader(),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (event) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventBannerWidget(imageUrl: event.bannerImage),
              const SizedBox(height: 16),
              Text(
                event.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.event_rounded, size: 18, color: Colors.green),
                  const SizedBox(width: 6),
                  Text('${event.date} • ${event.time}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 18, color: Colors.orange),
                  const SizedBox(width: 6),
                  Expanded(child: Text(event.location, style: const TextStyle(color: Colors.grey))),
                ],
              ),
              const Divider(height: 32),
              Text(
                event.description,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 32),
              if (event.ticketUrl.isNotEmpty)
                AppButton(
                  title: 'Get Tickets Now',
                  icon: Icons.confirmation_number_outlined,
                  onPressed: () => UrlHelper.launchURL(event.ticketUrl),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
