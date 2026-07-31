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
  String selectedCategory = 'All Shows';

  final List<String> categories = const [
    'All Shows',
    'Talk Shows',
    'Music',
    'Lifestyle',
    'News',
    'Sports',
  ];

  final List<Map<String, dynamic>> shows = const [
    {
      'id': 'show_1',
      'title': 'The Morning Drive',
      'host': 'with Tolu',
      'description': 'Start your day with great music, inspiring conversations and everything in between.',
      'time': '09:00 AM - 12:00 PM',
      'isLive': true,
      'category': 'Talk Shows',
      'image': 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80',
    },
    {
      'id': 'show_2',
      'title': 'Midday Vibes',
      'host': 'with Nia',
      'description': 'Good vibes and positive energy to keep you going all day.',
      'time': '12:00 PM - 03:00 PM',
      'isLive': false,
      'category': 'Music',
      'image': 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
    },
    {
      'id': 'show_3',
      'title': 'Afternoon Groove',
      'host': 'with Jay',
      'description': 'Feel the rhythm and groove through your afternoon.',
      'time': '03:00 PM - 06:00 PM',
      'isLive': false,
      'category': 'Music',
      'image': 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
    },
    {
      'id': 'show_4',
      'title': 'Evening Lounge',
      'host': 'with Zara',
      'description': 'Relax and unwind with smooth music and laid-back conversations.',
      'time': '06:00 PM - 09:00 PM',
      'isLive': false,
      'category': 'Lifestyle',
      'image': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=600&q=80',
    },
    {
      'id': 'show_5',
      'title': 'Night Ride',
      'host': 'with Raph',
      'description': 'The perfect mix to keep you company through the night.',
      'time': '09:00 PM - 12:00 AM',
      'isLive': false,
      'category': 'Talk Shows',
      'image': 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final audioNotifier = ref.read(audioPlayerProvider.notifier);

    final filteredShows = selectedCategory == 'All Shows'
        ? shows
        : shows.where((s) => s['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Header: Title & Categories Dropdown
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SHOWS',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF072654),
                      letterSpacing: 0.5,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (val) {
                      setState(() {
                        selectedCategory = val;
                      });
                    },
                    itemBuilder: (context) => categories
                        .map(
                          (cat) => PopupMenuItem(
                            value: cat,
                            child: Text(cat),
                          ),
                        )
                        .toList(),
                    child: Row(
                      children: const [
                        Text(
                          'Categories',
                          style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: AppColors.primaryOrange, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Category Filter Chips Row
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryOrange : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryOrange : Colors.grey[300]!,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryOrange.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF072654),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Vertical List of Shows Cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: filteredShows.length,
                itemBuilder: (context, index) {
                  final show = filteredShows[index];
                  final isLive = show['isLive'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Presenter Image Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(
                            imageUrl: show['image']!,
                            width: 90,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Show Details & Controls
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      show['title']!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: Color(0xFF072654),
                                      ),
                                    ),
                                  ),
                                  if (isLive) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF3B30),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.sensors, color: Colors.white, size: 10),
                                          SizedBox(width: 2),
                                          Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                show['host']!,
                                style: const TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                show['description']!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, color: AppColors.primaryOrange, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        show['time']!,
                                        style: const TextStyle(color: Color(0xFF072654), fontSize: 11, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      audioNotifier.playTrack(
                                        TrackItem(
                                          id: show['id']!,
                                          title: show['title']!,
                                          presenter: show['host']!,
                                          showName: show['title']!,
                                          image: show['image']!,
                                          streamUrl: 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3?filename=lofi-study-112191.mp3',
                                          isLive: isLive,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFFF4EE),
                                      ),
                                      child: const Icon(Icons.play_arrow, color: AppColors.primaryOrange, size: 22),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
