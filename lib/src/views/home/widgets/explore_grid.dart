import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/route_names.dart';

/// 5-item quick-nav explore grid matching the designer spec in Home Screen.png
/// Each item is a rounded dark navy container card holding both a bright blue icon
/// and centered white label text.
class ExploreGridWidget extends StatelessWidget {
  const ExploreGridWidget({super.key});

  static const _items = [
    _ExploreItem(icon: Icons.mic_rounded, label: 'Shows', route: RouteNames.shows),
    _ExploreItem(icon: Icons.calendar_month_rounded, label: 'Schedule', route: RouteNames.shows),
    _ExploreItem(icon: Icons.headphones_rounded, label: 'Podcasts', route: RouteNames.podcasts),
    _ExploreItem(icon: Icons.bar_chart_rounded, label: 'Charts', route: RouteNames.charts),
    _ExploreItem(icon: Icons.confirmation_number_outlined, label: 'Events', route: RouteNames.events),
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
            fontSize: 22,
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
    return Expanded(
      child: GestureDetector(
        onTap: () => context.push(item.route),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF071329),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF0F264E),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: const Color(0xFF0055FF),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: GoogleFonts.inter(
                  color: Colors.white,
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
  const _ExploreItem({required this.icon, required this.label, required this.route});
}
