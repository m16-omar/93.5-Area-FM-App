import 'package:flutter/material.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../const/app_colors.dart';
import '../../../../const/app_sizes.dart';
import '../../../models/radio_stream_model.dart';

class NowPlayingWidget extends StatelessWidget {
  final RadioStreamModel track;

  const NowPlayingWidget({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomNetworkImage(
          imageUrl: track.coverUrl,
          width: 260,
          height: 260,
          borderRadius: BorderRadius.circular(AppSizes.r20),
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sensors_rounded, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Text(
                'LIVE ON AIR',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          track.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          track.artist,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
