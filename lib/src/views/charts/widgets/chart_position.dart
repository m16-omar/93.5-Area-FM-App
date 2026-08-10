import 'package:flutter/material.dart';
import '../../../../const/app_colors.dart';

class ChartPositionWidget extends StatelessWidget {
  final int rank;

  const ChartPositionWidget({super.key, required this.rank});

  @override
  Widget build(BuildContext context) {
    Color rankColor;
    if (rank == 1) {
      rankColor = AppColors.accent;
    } else if (rank == 2) {
      rankColor = Colors.grey[400]!;
    } else if (rank == 3) {
      rankColor = Colors.brown[300]!;
    } else {
      rankColor = AppColors.primary;
    }

    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: rankColor.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Text(
        '#$rank',
        style: TextStyle(
          color: rankColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
