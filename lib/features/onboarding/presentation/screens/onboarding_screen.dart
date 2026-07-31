import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/area_fm_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _buildSlide1(context),
          _buildSlide2(context),
          _buildSlide3(context),
        ],
      ),
    );
  }

  // Slide 1: YOUR VOICE. YOUR VIBE.
  Widget _buildSlide1(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF041B3D), Color(0xFF020E22)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.12,
                          child: Icon(Icons.mic, size: 240, color: Colors.white),
                        ),
                        const AreaFMLogo(size: 130),
                      ],
                    ),
                    const SizedBox(height: 40),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'YOUR VOICE.\n',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                          TextSpan(
                            text: 'YOUR VIBE.',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryOrange,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Great music, real conversations, and unbeatable vibes 24/7.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (idx) {
                        final h = [14.0, 24.0, 36.0, 20.0, 12.0];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 4,
                          height: h[idx],
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              _buildBottomNav(context, showGetStarted: false),
            ],
          ),
        ),
      ),
    );
  }

  // Slide 2: LIVE RADIO ANYTIME, ANYWHERE.
  Widget _buildSlide2(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'LIVE RADIO',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondaryBlue,
                      ),
                    ),
                    Text(
                      'ANYTIME,\nANYWHERE.',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryOrange,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Listen to Area 93.5 FM live wherever you are.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mockup Radio Player Deck
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.darkBg,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondaryBlue.withValues(alpha: 0.25),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('• LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 14),
                      const AreaFMLogo(size: 80),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(9, (i) {
                          final barHeights = [12.0, 20.0, 32.0, 48.0, 28.0, 40.0, 22.0, 16.0, 10.0];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            width: 3.5,
                            height: barHeights[i],
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'The Morning Drive\nwith Tolu',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryOrange),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildBottomNav(context, isDarkText: true, showGetStarted: false),
            ],
          ),
        ),
      ),
    );
  }

  // Slide 3: SHOWS, PODCASTS & MORE.
  Widget _buildSlide3(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF041B3D), Color(0xFF020E22)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'SHOWS, PODCASTS',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const Text(
                '& MORE.',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Stay updated with your favorite shows, podcasts, events, and exclusive content.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Preview Content Cards
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(backgroundColor: AppColors.primaryOrange, child: Icon(Icons.mic, color: Colors.white)),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('The Morning Drive', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('09:00 AM - 12:00 PM', style: TextStyle(color: AppColors.primaryOrange, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(backgroundColor: AppColors.primaryBlue, child: Icon(Icons.podcasts, color: Colors.white)),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Building Better Habits', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('July 25, 2025 • Lifestyle', style: TextStyle(color: Colors.white60, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                  ),
                  child: const Text(
                    'GET STARTED',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, {bool isDarkText = false, bool showGetStarted = false}) {
    final textColor = isDarkText ? AppColors.textDark : Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => context.go('/home'),
          child: Text('SKIP', style: TextStyle(color: textColor.withValues(alpha: 0.7), fontWeight: FontWeight.bold)),
        ),
        Row(
          children: List.generate(3, (idx) {
            final isSelected = _currentPage == idx;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isSelected ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryOrange : (isDarkText ? Colors.grey[400] : Colors.white30),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        TextButton(
          onPressed: () {
            _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
          },
          child: const Text('NEXT', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
