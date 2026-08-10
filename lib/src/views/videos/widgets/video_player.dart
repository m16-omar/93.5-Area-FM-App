import 'package:flutter/material.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../const/app_colors.dart';

class VideoPlayerWidget extends StatelessWidget {
  final String thumbnailUrl;
  final VoidCallback onPlay;

  const VideoPlayerWidget({
    super.key,
    required this.thumbnailUrl,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlay,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomNetworkImage(
            imageUrl: thumbnailUrl,
            height: 220,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 48),
          ),
        ],
      ),
    );
  }
}
