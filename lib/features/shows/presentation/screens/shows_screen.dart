import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../live_radio/presentation/providers/audio_player_provider.dart';

class ShowsScreen extends ConsumerStatefulWidget {
  const ShowsScreen({super.key});

  @override
  ConsumerState<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends ConsumerState<ShowsScreen> {
  String selectedDay = 'Monday';
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  final List<Map<String, String>> shows = [
    {
      'title': 'Morning Vibe Blast',
      'host': 'Jordan Carter & DJ Spark',
      'time': '06:00 AM - 10:00 AM',
      'genre': 'Afrobeats & Urban Talk',
      'image': 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'The Midday Groove',
      'host': 'DJ Spark & Sarah Jenkins',
      'time': '10:00 AM - 02:00 PM',
      'genre': 'Top 40 & Pop Hits',
      'image': 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Area Drive Time',
      'host': 'Marcus Vibe',
      'time': '02:00 PM - 06:00 PM',
      'genre': 'Hip Hop & RnB Countdown',
      'image': 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Night Moods & Slow Jams',
      'host': 'Vanessa Cole',
      'time': '06:00 PM - 11:00 PM',
      'genre': 'Slow Jams & Soul',
      'image': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=600&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final audioNotifier = ref.read(audioPlayerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROGRAM SCHEDULE & SHOWS'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = day == selectedDay;

                return GestureDetector(
                  onTap: () => setState(() => selectedDay = day),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryOrange : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: shows.length,
              itemBuilder: (context, index) {
                final show = shows[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: show['image']!,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                show['time']!,
                                style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Text(show['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 2),
                              Text('Host: ${show['host']}', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: AppColors.primaryOrange, size: 34),
                          onPressed: () {
                            audioNotifier.playTrack(
                              TrackItem(
                                id: 'show_$index',
                                title: show['title']!,
                                presenter: show['host']!,
                                showName: show['title']!,
                                image: show['image']!,
                                streamUrl: 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=lofi-study-112191.mp3',
                                isLive: false,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
