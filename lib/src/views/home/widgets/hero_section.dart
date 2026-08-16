import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../const/app_colors.dart';
import '../../../../const/app_assets.dart';
import '../../../models/home_model.dart';
import '../../../providers/radio_player_provider.dart';

/// Sliding hero banner carousel matching the designer spec.
/// Allows users to swipe/slide horizontally between promotional banners,
/// featuring rounded card styling, live indicator, and play controls.
class HeroSectionWidget extends ConsumerStatefulWidget {
  final HomeModel data;
  const HeroSectionWidget({super.key, required this.data});

  @override
  ConsumerState<HeroSectionWidget> createState() => _HeroSectionWidgetState();
}

class _HeroSectionWidgetState extends ConsumerState<HeroSectionWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  static const List<_HeroSlideData> _slides = [
    _HeroSlideData(
      badge: 'LIVE',
      titlePrefix: '93.5 ',
      titleAccent: 'AREA ',
      titleSuffix: 'FM',
      subtitle: 'One Voice, Every Area',
      ctaText: 'LISTEN LIVE',
      gradientColors: [Color(0xFF085264), Color(0xFF0B6B82)],
      imageAsset: AppAssets.studioMicOnly,
    ),
    _HeroSlideData(
      badge: 'ON AIR',
      titlePrefix: 'THE MORNING ',
      titleAccent: 'RUSH',
      titleSuffix: '',
      subtitle: 'Weekdays 6:00 AM - 10:00 AM\nHosted by DJ Ace',
      ctaText: 'TUNE IN NOW',
      gradientColors: [Color(0xFF8B0000), Color(0xFFE50914)],
      imageAsset: AppAssets.studioMicOnly,
    ),
    _HeroSlideData(
      badge: 'FEATURED',
      titlePrefix: 'AREA ',
      titleAccent: 'MUSIC ',
      titleSuffix: 'CHARTS ',
      subtitle: 'Counting down the biggest hits\nacross Africa & the globe',
      ctaText: 'VIEW CHARTS',
      gradientColors: [Color(0xFF0F172A), Color(0xFF1E293B)],
      imageAsset: AppAssets.studioMicOnly,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerService = ref.watch(audioPlayerServiceProvider);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: slide.gradientColors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Right Side Hero Artwork
                      Positioned(
                        right: -5,
                        top: -10,
                        bottom: -10,
                        width: size.width * 0.48,
                        child: Image.asset(
                          slide.imageAsset,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                      // Contrast Fade Gradient Overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                slide.gradientColors.first,
                                slide.gradientColors.first.withValues(
                                  alpha: 0.92,
                                ),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Content Column
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // LIVE Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF3B30),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    slide.badge,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Title
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: slide.titlePrefix,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: slide.titleAccent,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: slide.titleSuffix,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3),
                            // Subtitle
                            Text(
                              slide.subtitle,
                              style: GoogleFonts.inter(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 12),
                            // CTA Pill Button
                            GestureDetector(
                              onTap: () => playerService.togglePlayPause(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: AppColors.primary,
                                        size: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      slide.ctaText,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Sliding Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : Colors.white24,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroSlideData {
  final String badge;
  final String titlePrefix;
  final String titleAccent;
  final String titleSuffix;
  final String subtitle;
  final String ctaText;
  final List<Color> gradientColors;
  final String imageAsset;

  const _HeroSlideData({
    required this.badge,
    required this.titlePrefix,
    required this.titleAccent,
    required this.titleSuffix,
    required this.subtitle,
    required this.ctaText,
    required this.gradientColors,
    required this.imageAsset,
  });
}
