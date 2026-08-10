import 'package:flutter/material.dart';
import '../../../../common/components/podcast_card.dart';
import '../../../models/podcast_model.dart';

class PodcastCardWidget extends StatelessWidget {
  final PodcastModel podcast;
  final VoidCallback onTap;

  const PodcastCardWidget({
    super.key,
    required this.podcast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PodcastCard(podcast: podcast, onTap: onTap);
  }
}
