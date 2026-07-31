import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, String>> searchItems = const [
    {'title': 'Morning Vibe Blast', 'type': 'Show', 'subtitle': 'With Jordan Carter & DJ Spark'},
    {'title': 'The Fan Zone #1', 'type': 'Podcast', 'subtitle': 'Sports Extra Podcast'},
    {'title': '93.5 Area FM Unveils New Studio', 'type': 'News', 'subtitle': 'Station News & Upgrades'},
    {'title': 'DJ Spark', 'type': 'Presenter', 'subtitle': 'Head DJ & Midday Curator'},
    {'title': 'Annual City Music Festival', 'type': 'Event', 'subtitle': 'August 24, 2026'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = searchItems.where((item) {
      final q = _query.toLowerCase();
      return item['title']!.toLowerCase().contains(q) ||
          item['type']!.toLowerCase().contains(q) ||
          item['subtitle']!.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search shows, podcasts, news, DJs...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          onChanged: (val) {
            setState(() {
              _query = val;
            });
          },
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _query = '';
                });
              },
            ),
        ],
      ),
      body: filtered.isEmpty
          ? const Center(
              child: Text('No matching results found', style: TextStyle(color: AppColors.textMuted)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.15),
                    child: Icon(
                      item['type'] == 'Show'
                          ? Icons.radio
                          : item['type'] == 'Podcast'
                              ? Icons.podcasts
                              : item['type'] == 'News'
                                  ? Icons.newspaper
                                  : item['type'] == 'Presenter'
                                      ? Icons.person
                                      : Icons.event,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item['type']} • ${item['subtitle']}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {},
                );
              },
            ),
    );
  }
}
