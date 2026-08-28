import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../routes/route_names.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    );
    _progressController.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;
    context.go(RouteNames.onboarding);
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Studio Background Artwork
          Image.asset(
            AppAssets.splashBg,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              AppAssets.studioMicOnly,
              fit: BoxFit.cover,
            ),
          ),

          // 2. Subtle Dark Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.95),
                ],
                stops: const [0.0, 0.35, 0.75, 1.0],
              ),
            ),
          ),

          // 3. Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Branded Image Logo
                _SplashLogo(),

                const SizedBox(height: 18),

                // Tagline: "Where Music Lives & the Beat Never Stops"
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Where ',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      TextSpan(
                        text: 'Music Lives\n',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFF5500),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      TextSpan(
                        text: '& the Beat Never Stops',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 4),

                // Loading Text (Bright, crisp white and on top of bar)
                Text(
                  'LOADING...',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                  ),
                ),

                const SizedBox(height: 10),

                // Animated Progress Bar (Thick, rounded, bright orange indicator with dark track)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Container(
                        height: 6.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressAnimation.value.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF4500),
                                  Color(0xFFFF6A00),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5500).withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      height: 85,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '93.5\n',
              style: GoogleFonts.bebasNeue(
                fontSize: 34,
                color: Colors.white,
                letterSpacing: 4,
                height: 1.0,
              ),
            ),
            TextSpan(
              text: 'AREA ',
              style: GoogleFonts.bebasNeue(
                fontSize: 54,
                color: AppColors.primary,
                letterSpacing: 4,
                height: 0.95,
              ),
            ),
            TextSpan(
              text: 'FM',
              style: GoogleFonts.bebasNeue(
                fontSize: 54,
                color: Colors.white,
                letterSpacing: 4,
                height: 0.95,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
