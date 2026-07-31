import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    final audioNotifier = ref.read(audioPlayerProvider.notifier);
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

      // Mini Player + Bottom Navigation Bar Stack
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Persistent Audio Mini Player Bar (Matching Design)
          InkWell(
            onTap: () => context.push('/live_radio'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF031A3D),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: track.image,
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${track.title} with ${track.presenter}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Text('On Air', style: TextStyle(color: AppColors.primaryOrange, fontSize: 11, fontWeight: FontWeight.bold)),
                            const Text(' • ', style: TextStyle(color: Colors.white54, fontSize: 11)),
                            Text(
                              _formatDuration(audioState.position),
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 24),
                        onPressed: () {},
                      ),
                      InkWell(
                        onTap: () => audioNotifier.togglePlayPause(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryOrange,
                          ),
                          child: Icon(
                            audioState.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 24),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF041D44),
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
        ],
      ),
    );
  }

  String _formatDuration(Duration dur) {
    if (dur == Duration.zero) return '00:45:32';
    final hours = dur.inHours;
    final minutes = dur.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = dur.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
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
