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
    final borderWidth = (2.5 * scale).clamp(1.5, 3.5);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 5 * scale),
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            borderRadius: BorderRadius.circular(12 * scale),
            border: Border.all(color: Colors.white, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrange.withValues(alpha: 0.3),
                blurRadius: 10 * scale,
                spreadRadius: 1 * scale,
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
                  fontSize: (20 * scale).clamp(9.0, 24.0),
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  letterSpacing: 1.5 * scale,
                  height: 1.0,
                ),
              ),
              // AREA Banner
              Container(
                margin: EdgeInsets.symmetric(vertical: 1.5 * scale),
                padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 1.5 * scale),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(4 * scale),
                ),
                child: Text(
                  'AREA',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: (24 * scale).clamp(10.0, 30.0),
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2 * scale,
                    height: 1.0,
                  ),
                ),
              ),
              // FM
              Text(
                'FM',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: (18 * scale).clamp(8.0, 22.0),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 3 * scale,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        if (showTagline) ...[
          SizedBox(height: 14 * scale),
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
