import 'package:flutter/material.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../const/app_colors.dart';
import '../../../../const/app_sizes.dart';
import '../../../models/chart_model.dart';
import 'chart_position.dart';

class ChartItemWidget extends StatelessWidget {
  final ChartModel track;
  final VoidCallback onPlay;

  const ChartItemWidget({
    super.key,
    required this.track,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        children: [
          ChartPositionWidget(rank: track.rank),
          const SizedBox(width: 12),
          CustomNetworkImage(
            imageUrl: track.albumCover,
            width: 50,
            height: 50,
            borderRadius: BorderRadius.circular(AppSizes.r8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  track.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  '${track.votes} votes • ${track.peakPosition}',
                  style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 36),
            onPressed: onPlay,
          ),
        ],
      ),
    );
  }
}
