import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/widgets/app_button.dart';
import '../../../const/app_colors.dart';
import '../../providers/shows_provider.dart';
import '../../services/share_service.dart';

class ShowDetailsView extends ConsumerWidget {
  final String id;

  const ShowDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAsync = ref.watch(showDetailsProvider(id));

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Show Overview',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              showAsync.whenData((s) => ShareService.shareShow(s.title, s.airTime));
            },
          ),
        ],
      ),
      body: showAsync.when(
        loading: () => const AppLoader(),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (show) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetworkImage(
                imageUrl: show.image,
                height: 220,
                width: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(height: 16),
              Text(
                show.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Hosted by ${show.presenter}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    '${show.days} (${show.airTime})',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
              const Divider(height: 32),
              const Text(
                'About the Show',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                show.description,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 32),
              AppButton(
                title: 'Set Reminder',
                icon: Icons.notifications_active_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reminder set for ${show.title}!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
