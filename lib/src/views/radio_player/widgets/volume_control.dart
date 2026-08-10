import 'package:flutter/material.dart';
import '../../../../const/app_colors.dart';

class VolumeControlWidget extends StatelessWidget {
  final double volume;
  final bool isMuted;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onMuteToggle;

  const VolumeControlWidget({
    super.key,
    required this.volume,
    required this.isMuted,
    required this.onVolumeChanged,
    required this.onMuteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(isMuted || volume == 0 ? Icons.volume_off_rounded : Icons.volume_down_rounded),
          onPressed: onMuteToggle,
        ),
        Expanded(
          child: Slider(
            value: isMuted ? 0 : volume,
            activeColor: AppColors.primary,
            onChanged: onVolumeChanged,
          ),
        ),
        const Icon(Icons.volume_up_rounded),
      ],
    );
  }
}
