import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../const/app_assets.dart';
import '../../../models/show_model.dart';

/// Horizontal scroll of featured show cards rendering the exact designer artwork
/// assets (show1.png, show2.png, show3.png, show4.png) matching Home Screen.png.
class FeaturedShowsWidget extends StatelessWidget {
  final List<ShowModel> shows;
  const FeaturedShowsWidget({super.key, required this.shows});

  static const _showAssets = [
    AppAssets.show1,
    AppAssets.show2,
    AppAssets.show3,
    AppAssets.show4,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _showAssets.length,
        itemBuilder: (context, index) {
          final showAsset = _showAssets[index];
          final showId = index < shows.length ? shows[index].id : 'show_${index + 1}';

          return GestureDetector(
            onTap: () => context.push('/show_details/$showId'),
            child: Container(
              width: 165,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  showAsset,
                  width: 165,
                  height: 215,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF001F54),
                    child: const Center(
                      child: Icon(Icons.mic, color: Colors.white, size: 36),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
