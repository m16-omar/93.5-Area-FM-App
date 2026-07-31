import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../live_radio/presentation/providers/audio_player_provider.dart';

class PodcastsScreen extends ConsumerStatefulWidget {
  const PodcastsScreen({super.key});

  @override
  ConsumerState<PodcastsScreen> createState() => _PodcastsScreenState();
}

class _PodcastsScreenState extends ConsumerState<PodcastsScreen> {
  bool isGridView = false;
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> podcasts = [
    {
      'title': 'The Fan Zone #1',
      'host': 'Alex Rivera',
      'category': 'Sports & Talk',
      'episodes': '12 Episodes',
      'image': 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Future Tech & Tomorrow',
      'host': 'Elena Vance',
      'category': 'Technology',
      'episodes': '8 Episodes',
      'image': 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Gospel Beats & Praise',
      'host': 'Pastor David',
      'category': 'Gospel',
      'episodes': '15 Episodes',
      'image': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=600&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final audioNotifier = ref.read(audioPlayerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ON-DEMAND PODCASTS'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view, color: Colors.white),
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isGridView ? _buildGrid(audioNotifier) : _buildList(audioNotifier),
      ),
    );
  }

  Widget _buildList(AudioPlayerNotifier audioNotifier) {
    return ListView.builder(
      itemCount: podcasts.length,
      itemBuilder: (context, index) {
        final pod = podcasts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(imageUrl: pod['image'], width: 56, height: 56, fit: BoxFit.cover),
            ),
            title: Text(pod['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${pod['host']} • ${pod['episodes']}'),
            trailing: IconButton(
              icon: const Icon(Icons.play_circle_fill, color: AppColors.primaryOrange, size: 32),
              onPressed: () {
                audioNotifier.playTrack(
                  TrackItem(
                    id: 'podcast_$index',
                    title: pod['title'],
                    presenter: pod['host'],
                    showName: 'Podcast Episode',
                    image: pod['image'],
                    streamUrl: 'https://cdn.pixabay.com/download/audio/2022/03/15/audio_c8c8a6a43e.mp3?filename=funky-synthwave-111668.mp3',
                    isLive: false,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrid(AudioPlayerNotifier audioNotifier) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: podcasts.length,
      itemBuilder: (context, index) {
        final pod = podcasts[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(imageUrl: pod['image'], height: 110, width: double.infinity, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pod['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(pod['host'], style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
