import 'package:flutter/material.dart';
import '../../../../const/app_colors.dart';

class PodcastPlayerWidget extends StatelessWidget {
  final String title;
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const PodcastPlayerWidget({
    super.key,
    required this.title,
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 36, color: AppColors.primary),
            onPressed: onPlayPause,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
