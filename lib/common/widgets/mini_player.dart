import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/app_colors.dart';
import '../../src/providers/radio_player_provider.dart';
import '../../src/routes/route_names.dart';

/// Persistent mini player bar at the bottom of the shell scaffold.
/// Matches designer: dark navy bg, logo, station name, LIVE badge + waveform,
/// pause/play button, expand chevron, and hide/close button when not playing.
class MiniPlayerWidget extends ConsumerWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerService = ref.watch(audioPlayerServiceProvider);
    final isPlaying = playerService.isPlaying;
    final currentTrack = playerService.currentTrack;

    if (playerService.isDismissed) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.navyBlue,
        border: const Border(
          top: BorderSide(color: AppColors.royalBlue, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // Logo / Cover Thumbnail
            GestureDetector(
              onTap: () => context.push(RouteNames.radioPlayer),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.royalBlue,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.brandBlue.withValues(alpha: 0.5), width: 1),
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '93.5\n',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 8,
                            color: Colors.white,
                            letterSpacing: 1,
                            height: 1.3,
                          ),
                        ),
                        TextSpan(
                          text: 'AREA',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 12,
                            color: AppColors.primary,
                            letterSpacing: 1,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Station info
            Expanded(
              child: GestureDetector(
                onTap: () => context.push(RouteNames.radioPlayer),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentTrack.title.isNotEmpty
                          ? currentTrack.title
                          : '93.5 AREA FM',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentTrack.artist.isNotEmpty
                          ? currentTrack.artist
                          : 'Where Music Lives & the Beat Never Stops',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondaryDark,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isPlaying) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'LIVE',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 10,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          _WaveformIndicator(),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Play/Pause button
            GestureDetector(
              onTap: () => playerService.togglePlayPause(),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Close / Hide Button (Dismisses mini player when not playing or when user taps close)
            GestureDetector(
              onTap: () {
                if (!isPlaying) {
                  playerService.dismissMiniPlayer();
                } else {
                  context.push(RouteNames.radioPlayer);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  isPlaying ? Icons.keyboard_arrow_up_rounded : Icons.close_rounded,
                  color: AppColors.textSecondaryDark,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated LIVE waveform bars
class _WaveformIndicator extends StatefulWidget {
  @override
  State<_WaveformIndicator> createState() => _WaveformIndicatorState();
}

class _WaveformIndicatorState extends State<_WaveformIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(5, (i) {
            final height = 4.0 + (8.0 * ((i % 2 == 0)
                ? _controller.value
                : (1 - _controller.value)));
            return Container(
              width: 3,
              height: height,
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
