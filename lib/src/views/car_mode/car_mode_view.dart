import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../common/widgets/network_image.dart';
import '../../providers/radio_player_provider.dart';

/// Distraction-free, high-contrast Car Mode view for safe in-car audio listening.
class CarModeView extends ConsumerWidget {
  const CarModeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerService = ref.watch(audioPlayerServiceProvider);
    final track = playerService.currentTrack;
    final isPlaying = playerService.isPlaying;

    return Scaffold(
      backgroundColor: const Color(0xFF071216),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top Bar with Exit Car Mode Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.directions_car_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'CAR MODE',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16323E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFF1E4353)),
                      ),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    label: Text(
                      'Exit',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Huge Station Cover Artwork
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.oceanBlue.withValues(alpha: 0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: CustomNetworkImage(
                      imageUrl: track.coverUrl,
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Station / Track Title
              Text(
                track.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                track.artist,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Giant Controls Row (Prev / Play-Pause / Next)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    iconSize: 52,
                    icon: const Icon(Icons.skip_previous_rounded, color: Colors.white70),
                  ),

                  // Giant Play Button
                  GestureDetector(
                    onTap: () => playerService.togglePlayPause(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: isPlaying ? AppColors.primary : AppColors.oceanBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isPlaying ? AppColors.primary : AppColors.oceanBlue)
                                .withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 56,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    iconSize: 52,
                    icon: const Icon(Icons.skip_next_rounded, color: Colors.white70),
                  ),
                ],
              ),

              const Spacer(),

              // Huge Volume Control Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B1B22),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF1E4353)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        playerService.isMuted ? Icons.volume_off_rounded : Icons.volume_down_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => playerService.toggleMute(),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 10,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: const Color(0xFF1E4353),
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: playerService.isMuted ? 0 : playerService.volume,
                          onChanged: (val) => playerService.setVolume(val),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 28),
                      onPressed: () => playerService.setVolume(1.0),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
