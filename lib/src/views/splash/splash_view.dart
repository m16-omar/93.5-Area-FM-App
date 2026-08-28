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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF030D18),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Studio Microphone Artwork on top-right with smooth fade
          Positioned(
            right: -10,
            top: 20,
            width: size.width * 0.75,
            height: size.height * 0.52,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                  ],
                  stops: [0.0, 0.4],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                AppAssets.studioMicTransparent,
                fit: BoxFit.contain,
                alignment: Alignment.topRight,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  AppAssets.studioMicOnly,
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                ),
              ),
            ),
          ),

          // 2. Soundwave Equalizer Graphic in Center
          Center(
            child: Opacity(
              opacity: 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(24, (i) {
                  final heights = [
                    0.2, 0.35, 0.5, 0.7, 0.4, 0.85, 0.6, 0.95, 0.75, 0.55, 0.9, 0.65,
                    0.65, 0.9, 0.55, 0.75, 0.95, 0.6, 0.85, 0.4, 0.7, 0.5, 0.35, 0.2
                  ];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: 2.5,
                    height: 140 * heights[i % heights.length],
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5500),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5500).withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),

          // 3. Dark Gradient Overlay to ensure maximum contrast
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF030D18).withValues(alpha: 0.5),
                  Colors.transparent,
                  const Color(0xFF030D18).withValues(alpha: 0.85),
                  const Color(0xFF030D18),
                ],
                stops: const [0.0, 0.35, 0.75, 1.0],
              ),
            ),
          ),

          // 4. Content (Logo, Tagline, Loading Indicator)
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Brand Logo
                _SplashLogo(),

                const SizedBox(height: 18),

                // Tagline: "One Voice, Every Area"
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'One Voice, ',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                      TextSpan(
                        text: 'Every Area',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFF5500),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 4),

                // LOADING Text (Bold & bright white above the progress bar)
                Text(
                  'LOADING...',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                  ),
                ),

                const SizedBox(height: 10),

                // Animated Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Container(
                        height: 6.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
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
                                  Color(0xFFFF7A00),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5500).withValues(alpha: 0.5),
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
      height: 90,
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
