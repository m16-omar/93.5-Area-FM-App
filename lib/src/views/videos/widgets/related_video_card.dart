import 'package:flutter/material.dart';
import '../../../../common/components/video_card.dart';
import '../../../models/video_model.dart';

class RelatedVideoCardWidget extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;

  const RelatedVideoCardWidget({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VideoCard(video: video, onTap: onTap);
  }
}
