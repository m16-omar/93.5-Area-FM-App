import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/area_fm_logo.dart';
import '../../../live_radio/presentation/providers/audio_player_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final audioNotifier = ref.read(audioPlayerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // White Header Row (Matching Image 1 Exactly)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Orange Hamburger Menu Icon
                    IconButton(
                      icon: const Icon(Icons.menu, color: AppColors.primaryOrange, size: 28),
                      onPressed: () => context.push('/settings'),
                    ),

                    // Central 93.5 Area FM Badge Logo
                    const AreaFMLogo(size: 60),

                    // Right Search and Play Buttons
                    Row(
                      children: [
                        InkWell(
                          onTap: () => context.push('/search'),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFFF4EE),
                            ),
                            child: const Icon(Icons.search, color: AppColors.primaryOrange, size: 22),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () => audioNotifier.togglePlayPause(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryOrange,
                              boxShadow: [
                                BoxShadow(color: AppColors.primaryOrange, blurRadius: 10, spreadRadius: 1),
                              ],
                            ),
                            child: Icon(
                              audioState.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Hero Carousel Banner Card (Matching Image 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF041D44), Color(0xFF0B3068)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF041D44).withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Opacity(
                          opacity: 0.18,
                          child: Icon(Icons.mic, size: 180, color: AppColors.primaryOrange),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, color: Colors.white, size: 8),
                                SizedBox(width: 4),
                                Text('ON AIR', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'YOUR VOICE.\n',
                                  style: TextStyle(fontFamily: 'Outfit', fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                                ),
                                TextSpan(
                                  text: 'YOUR VIBE.',
                                  style: TextStyle(fontFamily: 'Outfit', fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primaryOrange),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(
                            width: 210,
                            child: Text(
                              'Great music, real conversations, and unbeatable vibes 24/7.',
                              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => context.push('/live_radio'),
                                icon: const Icon(Icons.play_circle_fill, size: 18, color: Colors.white),
                                label: const Text('LISTEN LIVE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryOrange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton.icon(
                                onPressed: () => context.push('/shows'),
                                icon: const Icon(Icons.calendar_month, size: 18, color: Colors.white),
                                label: const Text('SCHEDULE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white54, width: 1.5),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 12, height: 6, decoration: BoxDecoration(color: AppColors.primaryOrange, borderRadius: BorderRadius.circular(3))),
                              const SizedBox(width: 4),
                              Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(3))),
                              const SizedBox(width: 4),
                              Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(3))),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // TRENDING SHOWS Section
              _buildSectionHeader(context, title: 'TRENDING SHOWS', route: '/shows'),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildTrendingShowCard(
                      title: 'THE MORNING\nDRIVE',
                      host: 'with Tolu',
                      time: '09:00 AM - 12:00 PM',
                      imageUrl: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80',
                    ),
                    _buildTrendingShowCard(
                      title: 'MIDDAY\nVIBES',
                      host: 'with Nia',
                      time: '12:00 PM - 03:00 PM',
                      imageUrl: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
                    ),
                    _buildTrendingShowCard(
                      title: 'AFTERNOON\nGROOVE',
                      host: 'with Jay',
                      time: '03:00 PM - 06:00 PM',
                      imageUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
                    ),
                    _buildTrendingShowCard(
                      title: 'EVENING\nLOUNGE',
                      host: 'with Zara',
                      time: '06:00 PM - 09:00 PM',
                      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=600&q=80',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // RECENT PODCASTS Section
              _buildSectionHeader(context, title: 'RECENT PODCASTS', route: '/podcasts'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildPodcastTile(
                      context,
                      ref,
                      title: 'The Power of Consistency',
                      subtitle: 'July 28, 2025 • Motivation',
                      duration: '45:12',
                      imageUrl: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80',
                    ),
                    _buildPodcastTile(
                      context,
                      ref,
                      title: 'Building Better Habits',
                      subtitle: 'July 25, 2025 • Lifestyle',
                      duration: '32:18',
                      imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=600&q=80',
                    ),
                    _buildPodcastTile(
                      context,
                      ref,
                      title: 'New Music Friday',
                      subtitle: 'July 23, 2025 • Music',
                      duration: '28:40',
                      imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=600&q=80',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // UPCOMING EVENTS Section
              _buildSectionHeader(context, title: 'UPCOMING EVENTS', route: '/events'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF041D44), Color(0xFF072C61)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF041D44).withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 74,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: const BoxDecoration(
                          color: Color(0xFF072654),
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('AUG', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                            Text('10', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                            Text('SUN', style: TextStyle(color: AppColors.primaryOrange, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Area 93.5 Live Music Concert',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: AppColors.primaryOrange, size: 14),
                                  SizedBox(width: 4),
                                  Text('Freedom Park, Lagos', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: AppColors.primaryOrange, size: 14),
                                  SizedBox(width: 4),
                                  Text('6:00 PM - 10:00 PM', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required String route}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Color(0xFF072654),
              letterSpacing: 0.5,
            ),
          ),
          InkWell(
            onTap: () => context.push(route),
            child: Row(
              children: const [
                Text('View all', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(width: 2),
                Icon(Icons.arrow_forward, color: AppColors.primaryOrange, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingShowCard({
    required String title,
    required String host,
    required String time,
    required String imageUrl,
  }) {
    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.4), BlendMode.darken),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Outfit', color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, height: 1.1)),
                const SizedBox(height: 2),
                Text(host, style: const TextStyle(color: AppColors.primaryOrange, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFF072654),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcastTile(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required String duration,
    required String imageUrl,
  }) {
    final audioNotifier = ref.read(audioPlayerProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(imageUrl: imageUrl, width: 54, height: 54, fit: BoxFit.cover),
              ),
              InkWell(
                onTap: () {
                  audioNotifier.playTrack(
                    TrackItem(
                      id: title,
                      title: title,
                      presenter: subtitle,
                      showName: 'Podcast Episode',
                      image: imageUrl,
                      streamUrl: 'https://cdn.pixabay.com/download/audio/2022/03/15/audio_c8c8a6a43e.mp3?filename=funky-synthwave-111668.mp3',
                      isLive: false,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(Icons.play_arrow, color: Color(0xFF072654), size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF072654))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF2F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(duration, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF072654))),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.more_vert, color: AppColors.primaryOrange, size: 20),
        ],
      ),
    );
  }
}
