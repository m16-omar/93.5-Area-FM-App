import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../live_radio/presentation/providers/audio_player_provider.dart';

class MainShellScaffold extends ConsumerWidget {
  final Widget child;

  const MainShellScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/live_radio')) return 1;
    if (location.startsWith('/shows')) return 2;
    if (location.startsWith('/podcasts')) return 3;
    if (location.startsWith('/presenters')) return 4;
    if (location.startsWith('/news')) return 5;
    if (location.startsWith('/settings')) return 6;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final audioNotifier = ref.read(audioPlayerProvider.notifier);
    final track = audioState.currentTrack;
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Persistent Bottom Mini-Player
          GestureDetector(
            onTap: () => context.push('/live_radio'),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkCard
                    : AppColors.secondaryBlue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryOrange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                track.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '93.5 Area FM • ${track.presenter}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: audioState.isBuffering
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Icon(
                            audioState.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            color: AppColors.primaryOrange,
                            size: 36,
                          ),
                    onPressed: () => audioNotifier.togglePlayPause(),
                  ),
                ],
              ),
            ),
          ),

          // Navigation Bar
          NavigationBar(
            selectedIndex: selectedIndex > 5 ? 5 : selectedIndex,
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/live_radio');
                  break;
                case 2:
                  context.go('/shows');
                  break;
                case 3:
                  context.go('/podcasts');
                  break;
                case 4:
                  context.go('/presenters');
                  break;
                case 5:
                  context.go('/news');
                  break;
              }
            },
            indicatorColor: AppColors.primaryOrange.withValues(alpha: 0.2),
            elevation: 8,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: AppColors.primaryOrange), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.radio_outlined), selectedIcon: Icon(Icons.radio, color: AppColors.primaryOrange), label: 'Live FM'),
              NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month, color: AppColors.primaryOrange), label: 'Shows'),
              NavigationDestination(icon: Icon(Icons.podcasts_outlined), selectedIcon: Icon(Icons.podcasts, color: AppColors.primaryOrange), label: 'Podcasts'),
              NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people, color: AppColors.primaryOrange), label: 'DJs'),
              NavigationDestination(icon: Icon(Icons.newspaper_outlined), selectedIcon: Icon(Icons.newspaper, color: AppColors.primaryOrange), label: 'News'),
            ],
          ),
        ],
      ),
    );
  }
}
