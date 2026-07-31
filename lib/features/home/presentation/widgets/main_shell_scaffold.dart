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
      body: Column(
        children: [
          // Topmost Announcement Bar
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 8),
            decoration: const BoxDecoration(color: Color(0xFF031A3D)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(12),
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
                // Top Social Icons
                _buildSocialIcon(Icons.facebook, AppConstants.facebookUrl),
                _buildSocialIcon(Icons.share, AppConstants.twitterUrl),
                _buildSocialIcon(Icons.camera_alt_outlined, AppConstants.instagramUrl),
                _buildSocialIcon(Icons.chat_bubble_outline, 'https://wa.me/${AppConstants.whatsappNumber}'),
              ],
            ),
          ),

          // Main Page Content
          Expanded(child: child),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/shows');
                  break;
                case 2:
                  context.go('/podcasts');
                  break;
                case 3:
                  context.go('/events');
                  break;
                case 4:
                  context.go('/settings');
                  break;
              }
            },
            backgroundColor: const Color(0xFF041B3D),
            indicatorColor: AppColors.primaryOrange.withValues(alpha: 0.25),
            elevation: 12,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Colors.white70),
                selectedIcon: Icon(Icons.home, color: AppColors.primaryOrange),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.music_note_outlined, color: Colors.white70),
                selectedIcon: Icon(Icons.music_note, color: AppColors.primaryOrange),
                label: 'Shows',
              ),
              NavigationDestination(
                icon: Icon(Icons.mic_none_outlined, color: Colors.white70),
                selectedIcon: Icon(Icons.mic, color: AppColors.primaryOrange),
                label: 'Podcasts',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined, color: Colors.white70),
                selectedIcon: Icon(Icons.calendar_month, color: AppColors.primaryOrange),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.more_horiz_outlined, color: Colors.white70),
                selectedIcon: Icon(Icons.more_horiz, color: AppColors.primaryOrange),
                label: 'More',
              ),
            ],
          ),
        ],
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
