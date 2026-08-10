import 'package:flutter/material.dart';
import '../../const/app_colors.dart';
import '../../src/models/presenter_model.dart';
import '../widgets/network_image.dart';

class PresenterCard extends StatelessWidget {
  final PresenterModel presenter;
  final VoidCallback onTap;

  const PresenterCard({
    super.key,
    required this.presenter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            CustomNetworkImage(
              imageUrl: presenter.image,
              width: 90,
              height: 90,
              borderRadius: BorderRadius.circular(45),
            ),
            const SizedBox(height: 8),
            Text(
              presenter.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              presenter.showName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
