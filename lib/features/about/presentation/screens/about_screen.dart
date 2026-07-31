import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABOUT AREA 93.5 FM'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryOrange,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withValues(alpha: 0.4),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Icon(Icons.radio, color: Colors.white, size: 56),
            ),
            const SizedBox(height: 16),
            const Text(
              'AREA 93.5 FM',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const Text(
              'The Voice of the City • 24/7 Live Stream',
              style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Area 93.5 FM is the premier urban radio station delivering live music, groundbreaking talk shows, sports breakdown, and local news highlights. Designed for seamless iOS and Android mobile playback.',
                style: TextStyle(height: 1.6, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            const ListTile(
              leading: Icon(Icons.tune, color: AppColors.primaryBlue),
              title: Text('Broadcast Frequency'),
              subtitle: Text('93.5 MHz FM & Ultra HD Digital Mobile Stream'),
            ),
            const ListTile(
              leading: Icon(Icons.code, color: AppColors.primaryBlue),
              title: Text('Backend Architecture'),
              subtitle: Text('Django REST Framework Integration Ready'),
            ),
            const ListTile(
              leading: Icon(Icons.info_outline, color: AppColors.primaryBlue),
              title: Text('Version'),
              subtitle: Text('v2.0.0 Clean Architecture (Riverpod + GoRouter)'),
            ),
          ],
        ),
      ),
    );
  }
}
