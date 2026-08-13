import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../const/app_colors.dart';
import '../../../routes/route_names.dart';

/// 5-item quick-nav explore grid matching the designer spec in Home Screen.png
/// Each item is a rounded container card holding both a bright blue icon
/// and centered label text. Theme-aware for light and dark mode.
class ExploreGridWidget extends StatelessWidget {
  const ExploreGridWidget({super.key});

  static const _items = [
    _ExploreItem(
      icon: Icons.mic_rounded,
      label: 'Shows',
      route: RouteNames.shows,
    ),
    _ExploreItem(
      icon: Icons.calendar_month_rounded,
      label: 'Schedule',
      route: RouteNames.shows,
    ),
    _ExploreItem(
      icon: Icons.headphones_rounded,
      label: 'Podcasts',
      route: RouteNames.podcasts,
    ),
    _ExploreItem(
      icon: Icons.bar_chart_rounded,
      label: 'Charts',
      route: RouteNames.charts,
    ),
    _ExploreItem(
      icon: Icons.confirmation_number_outlined,
      label: 'Events',
      route: RouteNames.events,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPLORE',
          style: GoogleFonts.bebasNeue(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _items.map((item) {
            return _ExploreButton(item: item, isDark: isDark);
          }).toList(),
        ),
      ],
    );
  }
}

class _ExploreButton extends StatelessWidget {
  final _ExploreItem item;
  final bool isDark;
  const _ExploreButton({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.push(item.route),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0A1C24) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: const Color(0xFF0B6B82), size: 28),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreItem {
  final IconData icon;
  final String label;
  final String route;
  const _ExploreItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
