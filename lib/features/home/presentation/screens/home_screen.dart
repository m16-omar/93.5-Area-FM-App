import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../live_radio/presentation/providers/audio_player_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final audioNotifier = ref.read(audioPlayerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.radio, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AREA 93.5 FM',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                Text(
                  'Voice of the City',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 800));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Live Radio Card Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.sensors, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'ON AIR NOW',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.fullscreen, color: Colors.white, size: 28),
                          onPressed: () => context.push('/live_radio'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      audioState.currentTrack.title,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Presenter: ${audioState.currentTrack.presenter}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => audioNotifier.togglePlayPause(),
                      icon: Icon(
                        audioState.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 24,
                      ),
                      label: Text(audioState.isPlaying ? 'PAUSE STREAM' : 'LISTEN LIVE NOW'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Feature Hub Shortcut Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickChip(context, icon: Icons.calendar_month, label: 'Schedule', route: '/shows'),
                    _buildQuickChip(context, icon: Icons.podcasts, label: 'Podcasts', route: '/podcasts'),
                    _buildQuickChip(context, icon: Icons.people, label: 'Presenters', route: '/presenters'),
                    _buildQuickChip(context, icon: Icons.video_collection, label: 'Videos', route: '/videos'),
                    _buildQuickChip(context, icon: Icons.event, label: 'Events', route: '/events'),
                    _buildQuickChip(context, icon: Icons.photo_library, label: 'Gallery', route: '/gallery'),
                    _buildQuickChip(context, icon: Icons.info_outline, label: 'About', route: '/about'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Featured Shows Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('FEATURED SHOWS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  TextButton(
                    onPressed: () => context.push('/shows'),
                    child: const Text('View All', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildShowCard('Morning Vibe Blast', '06:00 - 10:00 AM', 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=600&q=80'),
                    _buildShowCard('Midday Groove', '10:00 - 02:00 PM', 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80'),
                    _buildShowCard('Area Drive Time', '02:00 - 06:00 PM', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Latest News Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TRENDING CITY NEWS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  TextButton(
                    onPressed: () => context.push('/news'),
                    child: const Text('Read News', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              _buildNewsItem(
                context,
                title: '93.5 Area FM Unveils High Definition Mobile Streaming Studio',
                category: 'Station News',
                date: 'July 30, 2026',
                imageUrl: 'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=600&q=80',
              ),
              _buildNewsItem(
                context,
                title: 'Annual City Music Festival Announced featuring Top Headliners',
                category: 'Events',
                date: 'July 28, 2026',
                imageUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=600&q=80',
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(BuildContext context, {required IconData icon, required String label, required String route}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        avatar: Icon(icon, size: 18, color: AppColors.primaryOrange),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        onSelected: (_) => context.push(route),
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildShowCard(String title, String time, String imgUrl) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.4), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(time, style: const TextStyle(color: AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(BuildContext context, {required String title, required String category, required String date, required String imageUrl}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: CachedNetworkImage(imageUrl: imageUrl, width: 100, height: 90, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: const TextStyle(color: AppColors.primaryOrange, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(date, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
