import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AreaFMLogo extends StatelessWidget {
  final double size;
  final bool showTagline;

  const AreaFMLogo({
    super.key,
    this.size = 120.0,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    final scale = size / 120.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 8 * scale),
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            borderRadius: BorderRadius.circular(16 * scale),
            border: Border.all(color: Colors.white, width: 3 * scale),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrange.withValues(alpha: 0.35),
                blurRadius: 16 * scale,
                spreadRadius: 2 * scale,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top 93.5 Frequency
              Text(
                '93.5',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  letterSpacing: 2 * scale,
                ),
              ),
              // AREA Banner
              Container(
                margin: EdgeInsets.symmetric(vertical: 2 * scale),
                padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 2 * scale),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(6 * scale),
                ),
                child: Text(
                  'AREA',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 28 * scale,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 3 * scale,
                  ),
                ),
              ),
              // FM
              Text(
                'FM',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20 * scale,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 4 * scale,
                ),
              ),
            ],
          ),
        ),
        if (showTagline) ...[
          SizedBox(height: 16 * scale),
          const Text(
            'YOUR VOICE.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const Text(
            'YOUR VIBE.',
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
