import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../routes/route_names.dart';
import '../../services/storage_service.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      title: 'WHERE',
      titleAccent: 'MUSIC LIVES',
      titleEnd: '& THE BEAT\nNEVER STOPS',
      subtitle: 'Your #1 hit music station bringing you the best shows, latest news and ',
      subtitleAccent: 'non-stop vibes.',
      features: [
        _FeatureItem(icon: Icons.radio_outlined, title: 'LIVE RADIO', desc: 'Listen live to 93.5 AREA FM anytime, anywhere.'),
        _FeatureItem(icon: Icons.mic_outlined, title: 'AMAZING SHOWS', desc: 'Top presenters, great shows and real conversations.'),
        _FeatureItem(icon: Icons.headphones_outlined, title: 'MUSIC 24/7', desc: 'The biggest hits and the best vibes, all day long.'),
      ],
    ),
    _OnboardingData(
      title: 'YOUR STATION.',
      titleAccent: 'YOUR VIBES.',
      titleEnd: 'YOUR WAY.',
      subtitle: 'Personalize your experience and stay connected to the shows, hosts and music ',
      subtitleAccent: 'you love.',
      features: [
        _FeatureItem(icon: Icons.favorite_border_rounded, title: 'FOLLOW YOUR FAVOURITES', desc: 'Follow your favourite shows and get updates when they go live.'),
        _FeatureItem(icon: Icons.notifications_active_outlined, title: 'STAY IN THE KNOW', desc: 'Get the latest news, events and exclusive station updates.'),
        _FeatureItem(icon: Icons.library_music_outlined, title: 'ALL THE MUSIC YOU LOVE', desc: 'From the biggest hits to underground gems.'),
      ],
    ),
    _OnboardingData(
      title: 'WELCOME TO',
      titleAccent: 'THE AREA',
      titleEnd: 'FAMILY!',
      subtitle: 'You\'re all set! Dive in and enjoy live radio, exciting shows, podcasts, videos and ',
      subtitleAccent: 'more.',
      features: [
        _FeatureItem(icon: Icons.radio_rounded, title: 'LIVE RADIO', desc: 'Listen to 93.5 AREA FM live anytime, anywhere.'),
        _FeatureItem(icon: Icons.tv_rounded, title: 'EXCITING SHOWS', desc: 'Catch your favourite shows and top presenters.'),
        _FeatureItem(icon: Icons.podcasts_rounded, title: 'PODCASTS & VIDEOS', desc: 'Listen on demand and watch exclusive content.'),
      ],
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    StorageService.setFirstLaunchDone();
    context.go(RouteNames.home);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (context, i) => _OnboardingPage(data: _pages[i]),
          ),
          // Skip button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 20),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Navigation Footer (Dots + Next/Get Started)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primary
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _nextPage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background studio graphic
        Positioned(
          right: -10,
          top: 0,
          width: size.width * 0.8,
          height: size.height * 0.45,
          child: Image.asset(
            AppAssets.studioMicOnly,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.75),
                Colors.black,
              ],
              stops: const [0.0, 0.35, 0.65],
            ),
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo top-center
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Center(child: _LogoText()),
              ),
              const SizedBox(height: 20),
              // Title area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${data.title}\n',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 38,
                              color: Colors.white,
                              letterSpacing: 2,
                              height: 0.95,
                            ),
                          ),
                          TextSpan(
                            text: '${data.titleAccent}\n',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 38,
                              color: AppColors.primary,
                              letterSpacing: 2,
                              height: 0.95,
                            ),
                          ),
                          TextSpan(
                            text: data.titleEnd,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 38,
                              color: Colors.white,
                              letterSpacing: 2,
                              height: 0.95,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: data.subtitle,
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          TextSpan(
                            text: data.subtitleAccent,
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Features list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: data.features
                      .map((f) => _FeatureTile(item: f))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      height: 38,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '93.5 ',
              style: GoogleFonts.bebasNeue(fontSize: 14, color: Colors.white, letterSpacing: 2),
            ),
            TextSpan(
              text: 'AREA ',
              style: GoogleFonts.bebasNeue(fontSize: 22, color: AppColors.primary, letterSpacing: 2),
            ),
            TextSpan(
              text: 'FM',
              style: GoogleFonts.bebasNeue(fontSize: 22, color: Colors.white, letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final _FeatureItem item;
  const _FeatureTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 15,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.desc,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 20),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String titleAccent;
  final String titleEnd;
  final String subtitle;
  final String subtitleAccent;
  final List<_FeatureItem> features;

  const _OnboardingData({
    required this.title,
    required this.titleAccent,
    required this.titleEnd,
    required this.subtitle,
    required this.subtitleAccent,
    required this.features,
  });
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.desc,
  });
}
