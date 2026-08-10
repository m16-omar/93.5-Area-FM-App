import 'package:flutter/material.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../const/app_sizes.dart';

class EventBannerWidget extends StatelessWidget {
  final String imageUrl;

  const EventBannerWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CustomNetworkImage(
      imageUrl: imageUrl,
      height: 200,
      width: double.infinity,
      borderRadius: BorderRadius.circular(AppSizes.r16),
    );
  }
}
