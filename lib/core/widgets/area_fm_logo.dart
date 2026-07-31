import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AreaFMLogo extends StatelessWidget {
  final double size;
  final bool showTagline;

  const AreaFMLogo({
    super.key,
    this.size = 60.0,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    final scale = size / 60.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // White Outer Glow / Border Emblem Box
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 4 * scale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10 * scale),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.15),
                    blurRadius: 8 * scale,
                    spreadRadius: 1 * scale,
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 3 * scale),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBlue,
                  borderRadius: BorderRadius.circular(8 * scale),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top 93.5 Frequency
                    Text(
                      '93.5',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13 * scale,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        letterSpacing: 1.2 * scale,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 1 * scale),
                    // AREA Banner Block
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 1 * scale),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.circular(3 * scale),
                      ),
                      child: Text(
                        'AREA',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2 * scale,
                          height: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 1 * scale),
                    // FM Text
                    Text(
                      'FM',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13 * scale,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2.5 * scale,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          SizedBox(height: 12 * scale),
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
