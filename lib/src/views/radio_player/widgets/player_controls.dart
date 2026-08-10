import 'package:flutter/material.dart';
import '../../../../const/app_colors.dart';

class PlayerControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPlayPause;

  const PlayerControlsWidget({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isBuffering)
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          )
        else
          GestureDetector(
            onTap: onPlayPause,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
