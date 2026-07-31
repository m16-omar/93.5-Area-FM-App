import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../live_radio/presentation/providers/audio_player_provider.dart';

class MainShellScaffold extends ConsumerWidget {
  final Widget child;

  const MainShellScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/shows')) return 1;
    if (location.startsWith('/podcasts')) return 2;
    if (location.startsWith('/events')) return 3;
    if (location.startsWith('/settings') || location.startsWith('/more') || location.startsWith('/about')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final track = audioState.currentTrack;
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Topmost Notification Header Bar (Matching Image)
          Container(
            padding: const EdgeInsets.only(top: 44, left: 16, right: 16, bottom: 10),
            decoration: const BoxDecoration(color: Color(0xFF041D44)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sensors, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${track.title} with ${track.presenter}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                // Social Links Icons
                _buildSocialIcon(Icons.facebook, AppConstants.facebookUrl),
                _buildSocialIcon(Icons.share, AppConstants.twitterUrl),
                _buildSocialIcon(Icons.camera_alt_outlined, AppConstants.instagramUrl),
                _buildSocialIcon(Icons.chat_bubble_outline, 'https://wa.me/${AppConstants.whatsappNumber}'),
              ],
            ),
          ),

          // Page Content
          Expanded(child: child),
        ],
      ),

      // Custom Bottom Navigation Bar matching Image 1 exactly
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF041D44),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _buildNavItem(context, index: 0, label: 'Home', icon: Icons.home, route: '/home', isSelected: selectedIndex == 0),
                _buildNavItem(context, index: 1, label: 'Shows', icon: Icons.music_note, route: '/shows', isSelected: selectedIndex == 1),
                _buildNavItem(context, index: 2, label: 'Podcasts', icon: Icons.mic, route: '/podcasts', isSelected: selectedIndex == 2),
                _buildNavItem(context, index: 3, label: 'Events', icon: Icons.calendar_month, route: '/events', isSelected: selectedIndex == 3),
                _buildNavItem(context, index: 4, label: 'More', icon: Icons.more_horiz, route: '/settings', isSelected: selectedIndex == 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required String label,
    required IconData icon,
    required String route,
    required bool isSelected,
  }) {
    final color = isSelected ? AppColors.primaryOrange : Colors.white;

    return Expanded(
      child: InkWell(
        onTap: () => context.go(route),
        child: Column(
          children: [
            // Top Selected Indicator Line
            Container(
              height: 3,
              width: isSelected ? 36 : 0,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(2)),
              ),
            ),
            const SizedBox(height: 8),
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String urlStr) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(urlStr);
        if (await canLaunchUrl(url)) await launchUrl(url);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(icon, color: Colors.white70, size: 16),
      ),
    );
  }
}
