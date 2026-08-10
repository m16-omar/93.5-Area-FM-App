import 'package:flutter/material.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../const/app_colors.dart';
import '../../../models/presenter_model.dart';

class PresenterHeroWidget extends StatelessWidget {
  final PresenterModel presenter;

  const PresenterHeroWidget({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomNetworkImage(
          imageUrl: presenter.image,
          width: 120,
          height: 120,
          borderRadius: BorderRadius.circular(60),
        ),
        const SizedBox(height: 16),
        Text(
          presenter.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          presenter.showName,
          style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
