import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../const/app_colors.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../models/show_model.dart';

/// Horizontal scroll of show tiles with alternating orange/blue backgrounds
/// matching the designer's card style
class FeaturedShowsWidget extends StatelessWidget {
  final List<ShowModel> shows;
  const FeaturedShowsWidget({super.key, required this.shows});

  // Alternating card accent colors from the designer
  static const _cardColors = [
    AppColors.navyBlue,
    AppColors.primary,
    AppColors.navyBlue,
    AppColors.primary,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: shows.length,
        itemBuilder: (context, index) {
          final show = shows[index];
          final cardColor = _cardColors[index % _cardColors.length];
          return GestureDetector(
            onTap: () => context.push('/show_details/${show.id}'),
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Presenter image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CustomNetworkImage(
                      imageUrl: show.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          cardColor.withValues(alpha: 0.3),
                          cardColor.withValues(alpha: 0.95),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show title at top
                        Text(
                          show.title.toUpperCase(),
                          style: GoogleFonts.bebasNeue(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1,
                            height: 1.1,
                          ),
                          maxLines: 3,
                        ),
                        const Spacer(),
                        // Presenter + play button row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    show.title,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    show.presenter,
                                    style: GoogleFonts.inter(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Time + days tags
                        Row(
                          children: [
                            _Tag(
                              text: show.days,
                              isOrange: cardColor == AppColors.navyBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final bool isOrange;
  const _Tag({required this.text, this.isOrange = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOrange
            ? AppColors.primary.withValues(alpha: 0.2)
            : AppColors.navyBlue.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isOrange ? AppColors.primary : AppColors.royalBlue,
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: isOrange ? AppColors.primary : Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
