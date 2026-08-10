import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../const/app_colors.dart';
import '../../../routes/route_names.dart';

/// 5-item quick-nav explore grid matching Home Screen.png
class ExploreGridWidget extends StatelessWidget {
  const ExploreGridWidget({super.key});

  static const _items = [
    _ExploreItem(icon: Icons.mic_rounded, label: 'Shows', route: RouteNames.shows),
    _ExploreItem(icon: Icons.calendar_month_outlined, label: 'Schedule', route: RouteNames.shows),
    _ExploreItem(icon: Icons.headphones_rounded, label: 'Podcasts', route: RouteNames.podcasts),
    _ExploreItem(icon: Icons.bar_chart_rounded, label: 'Charts', route: RouteNames.charts),
    _ExploreItem(icon: Icons.local_activity_outlined, label: 'Events', route: RouteNames.events),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPLORE',
          style: GoogleFonts.bebasNeue(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _items.map((item) {
            return _ExploreButton(item: item);
          }).toList(),
        ),
      ],
    );
  }
}

class _ExploreButton extends StatelessWidget {
  final _ExploreItem item;
  const _ExploreButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(item.route),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderDark, width: 0.5),
            ),
            child: Icon(item.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: GoogleFonts.inter(
              color: AppColors.textSecondaryDark,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreItem {
  final IconData icon;
  final String label;
  final String route;
  const _ExploreItem({required this.icon, required this.label, required this.route});
}
