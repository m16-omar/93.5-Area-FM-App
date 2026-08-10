import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/components/section_header.dart';
import '../../../../common/components/show_card.dart';
import '../../../models/show_model.dart';

class FeaturedShowsWidget extends StatelessWidget {
  final List<ShowModel> shows;

  const FeaturedShowsWidget({super.key, required this.shows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Popular Shows',
          actionText: 'See All',
          onActionTap: () => context.go('/shows'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: shows.length,
            itemBuilder: (context, index) => ShowCard(
              show: shows[index],
              onTap: () => context.push('/show_details/${shows[index].id}'),
            ),
          ),
        ),
      ],
    );
  }
}
