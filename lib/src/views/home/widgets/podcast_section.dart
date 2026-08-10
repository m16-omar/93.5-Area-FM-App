import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/components/section_header.dart';
import '../../../../common/components/podcast_card.dart';
import '../../../models/podcast_model.dart';

class PodcastSectionWidget extends StatelessWidget {
  final List<PodcastModel> podcasts;

  const PodcastSectionWidget({super.key, required this.podcasts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Trending Podcasts',
          actionText: 'Explore',
          onActionTap: () => context.go('/podcasts'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: podcasts.length,
            itemBuilder: (context, index) => PodcastCard(
              podcast: podcasts[index],
              onTap: () => context.push('/podcast_details/${podcasts[index].id}'),
            ),
          ),
        ),
      ],
    );
  }
}
