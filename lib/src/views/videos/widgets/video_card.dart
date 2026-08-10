import 'package:flutter/material.dart';
import '../../../../common/components/video_card.dart';
import '../../../models/video_model.dart';

class VideoCardWidget extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;

  const VideoCardWidget({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VideoCard(video: video, onTap: onTap);
  }
}
