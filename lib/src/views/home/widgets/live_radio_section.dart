import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../const/app_colors.dart';
import '../../../../const/app_assets.dart';
import '../../../providers/radio_player_provider.dart';
import '../../../models/show_model.dart';

/// ON AIR NOW card matching the exact designer reference in Home Screen.png:
/// Dark navy card with DJ Ace presenter thumbnail, ON AIR title, with DJ Ace,
/// time slot, and round blue audio visualizer waveform button. Theme-aware header.
class LiveRadioSectionWidget extends ConsumerWidget {
  final ShowModel show;
  const LiveRadioSectionWidget({super.key, required this.show});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerService = ref.watch(audioPlayerServiceProvider);
    final isPlaying = playerService.isPlaying;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ON AIR NOW',
                style: GoogleFonts.bebasNeue(
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  fontSize: 20,
                  letterSpacing: 1.2,
                ),
              ),
              GestureDetector(
                child: Text(
                  'See All',
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Show Card Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF071228) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF0F264A) : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Presenter photo thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    AppAssets.djAceOnAir,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: const Color(0xFF00246B),
                      child: const Icon(Icons.person, color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Show info details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Small Orange ON AIR Tag
                      Text(
                        'ON AIR',
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Title: The Morning Rush
                      Text(
                        'The Morning Rush',
                        style: GoogleFonts.poppins(
                          color: isDark ? Colors.white : const Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // Presenter: with DJ Ace
                      Text(
                        'with DJ Ace',
                        style: GoogleFonts.inter(
                          color: isDark ? const Color(0xFF8A99B5) : const Color(0xFF6B7280),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Time Slot: 🕒 6:00 AM - 10:00 AM
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: isDark ? const Color(0xFF8A99B5) : const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '6:00 AM - 10:00 AM',
                            style: GoogleFonts.inter(
                              color: isDark ? const Color(0xFF8A99B5) : const Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Blue Waveform Equalizer Action Button
                GestureDetector(
                  onTap: () => playerService.togglePlayPause(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isPlaying ? AppColors.primary : const Color(0xFF0044B4),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isPlaying ? AppColors.primary : const Color(0xFF0044B4)).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.graphic_eq_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
