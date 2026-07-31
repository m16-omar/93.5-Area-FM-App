import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';

class PresentersScreen extends StatelessWidget {
  const PresentersScreen({super.key});

  final List<Map<String, String>> presenters = const [
    {
      'name': 'Jordan Carter',
      'role': 'Morning Vibe Lead Host',
      'bio': 'Over 10 years of broadcast radio excellence, keeping the city awake and energetic every morning.',
      'image': 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80',
      'show': 'Morning Vibe Blast (06:00 AM - 10:00 AM)',
    },
    {
      'name': 'DJ Spark',
      'role': 'Head DJ & Midday Curator',
      'bio': 'Award-winning turntablist dropping non-stop hit mixes and urban Afrobeats countdowns.',
      'image': 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
      'show': 'The Midday Groove (10:00 AM - 02:00 PM)',
    },
    {
      'name': 'Marcus Vibe',
      'role': 'Drive Time Captain',
      'bio': 'Traffic updates, celebrity interviews, and high-octane drive-time entertainment.',
      'image': 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
      'show': 'Area Drive Time (02:00 PM - 06:00 PM)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DJs & PRESENTERS'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: presenters.length,
        itemBuilder: (context, index) {
          final p = presenters[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(imageUrl: p['image']!, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 2),
                      Text(p['role']!, style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text(p['bio']!, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, size: 16, color: AppColors.primaryBlue),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                p['show']!,
                                style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
