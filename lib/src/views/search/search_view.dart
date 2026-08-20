import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../controllers/search_controller.dart';
import '../../models/show_model.dart';
import '../../models/podcast_model.dart';
import '../../models/post_model.dart';
import '../../models/event_model.dart';
import '../../models/presenter_model.dart';
import '../../models/video_model.dart';
import '../../routes/route_names.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  late final TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(globalSearchProvider.notifier).search(value);
  }

  void _onSearchSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      ref.read(globalSearchProvider.notifier).addRecentSearch(value.trim());
    }
  }

  void _selectSearchTerm(String term) {
    _searchController.text = term;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
    ref.read(globalSearchProvider.notifier).search(term);
    ref.read(globalSearchProvider.notifier).addRecentSearch(term);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(globalSearchProvider);
    final searchNotifier = ref.read(globalSearchProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardBg = isDark ? const Color(0xFF0B1B22) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Bar Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: primaryTextColor,
                      size: 20,
                    ),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.go(RouteNames.home);
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  // Search Input Field
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0B1B22) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark ? const Color(0xFF14303D) : const Color(0xFFCBD5E1),
                        ),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        autofocus: true,
                        onChanged: _onSearchChanged,
                        onSubmitted: _onSearchSubmitted,
                        textInputAction: TextInputAction.search,
                        style: GoogleFonts.inter(
                          color: primaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search shows, podcasts, news, DJs...',
                          hintStyle: GoogleFonts.inter(
                            color: secondaryTextColor,
                            fontSize: 13.5,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: secondaryTextColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    searchNotifier.clearSearch();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Category Filter Pills
            if (_searchController.text.trim().isNotEmpty)
              _buildCategoryPills(searchState, searchNotifier, isDark),

            // 3. Body Content
            Expanded(
              child: _searchController.text.trim().isEmpty
                  ? _buildDefaultExploreView(searchState, searchNotifier, isDark)
                  : _buildSearchResultsView(
                      searchState,
                      searchNotifier,
                      isDark,
                      primaryTextColor,
                      secondaryTextColor,
                      cardBg,
                      cardBorder,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPills(
    SearchResultState state,
    GlobalSearchNotifier notifier,
    bool isDark,
  ) {
    final categories = [
      {'cat': SearchCategory.all, 'label': 'All (${state.totalResultsCount})'},
      {'cat': SearchCategory.shows, 'label': 'Shows (${state.shows.length})'},
      {'cat': SearchCategory.podcasts, 'label': 'Podcasts (${state.podcasts.length})'},
      {'cat': SearchCategory.news, 'label': 'News (${state.posts.length})'},
      {'cat': SearchCategory.events, 'label': 'Events (${state.events.length})'},
      {'cat': SearchCategory.presenters, 'label': 'DJs & Team (${state.presenters.length})'},
      {'cat': SearchCategory.videos, 'label': 'Videos (${state.videos.length})'},
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = categories[index];
          final cat = item['cat'] as SearchCategory;
          final label = item['label'] as String;
          final isSelected = state.selectedCategory == cat;

          return GestureDetector(
            onTap: () => notifier.setCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? const Color(0xFF0B1B22) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0)),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : const Color(0xFF475569)),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultExploreView(
    SearchResultState state,
    GlobalSearchNotifier notifier,
    bool isDark,
  ) {
    final primaryTextColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final trendingTerms = [
      'Morning Drive',
      'Afrobeats Reloaded',
      'DJ Tobi',
      'Area Concert 2024',
      'The Fan Zone',
      'Lagos Metro News',
      'Night Vibes',
      'Street Talk',
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        // 1. Recent Searches
        if (state.recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT SEARCHES',
                style: GoogleFonts.inter(
                  color: isDark ? const Color(0xFF00A3FF) : const Color(0xFF0B6B82),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              GestureDetector(
                onTap: () => notifier.clearRecentSearches(),
                child: Text(
                  'Clear All',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.recentSearches.map((term) {
              return GestureDetector(
                onTap: () => _selectSearchTerm(term),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0B1B22) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 14,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        term,
                        style: GoogleFonts.inter(
                          color: primaryTextColor,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => notifier.removeRecentSearch(term),
                        child: Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // 2. Trending Searches
        Text(
          'TRENDING ON AREA 93.5 FM',
          style: GoogleFonts.inter(
            color: isDark ? const Color(0xFF00A3FF) : const Color(0xFF0B6B82),
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: trendingTerms.map((term) {
            return GestureDetector(
              onTap: () => _selectSearchTerm(term),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B1B22) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF14303D) : const Color(0xFFCBD5E1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      term,
                      style: GoogleFonts.inter(
                        color: primaryTextColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // 3. Quick Browse Categories
        Text(
          'BROWSE CATEGORIES',
          style: GoogleFonts.inter(
            color: isDark ? const Color(0xFF00A3FF) : const Color(0xFF0B6B82),
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _BrowseCard(
              title: 'On-Air Shows',
              subtitle: 'Daily schedule & live shows',
              icon: Icons.mic_rounded,
              colors: const [Color(0xFF085264), Color(0xFF0B6B82)],
              onTap: () => context.push(RouteNames.shows),
            ),
            _BrowseCard(
              title: 'Podcasts',
              subtitle: 'On-demand audio series',
              icon: Icons.headphones_rounded,
              colors: const [Color(0xFF833AB4), Color(0xFFFD1D1D)],
              onTap: () => context.push(RouteNames.podcasts),
            ),
            _BrowseCard(
              title: 'News & Blog',
              subtitle: 'Latest stories & entertainment',
              icon: Icons.newspaper_rounded,
              colors: const [Color(0xFF0B6B82), Color(0xFF00A3FF)],
              onTap: () => context.push(RouteNames.blog),
            ),
            _BrowseCard(
              title: 'Live Events',
              subtitle: 'Concerts & city meetups',
              icon: Icons.local_activity_rounded,
              colors: const [Color(0xFFE65100), Color(0xFFFF9100)],
              onTap: () => context.push(RouteNames.events),
            ),
            _BrowseCard(
              title: 'Presenters & DJs',
              subtitle: 'Voices behind the mic',
              icon: Icons.people_alt_rounded,
              colors: const [Color(0xFF004D40), Color(0xFF00BFA5)],
              onTap: () => context.push(RouteNames.presenters),
            ),
            _BrowseCard(
              title: 'Videos & Studio',
              subtitle: 'Visuals & acoustic sets',
              icon: Icons.play_circle_fill_rounded,
              colors: const [Color(0xFFB71C1C), Color(0xFFFF5252)],
              onTap: () => context.push(RouteNames.videos),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchResultsView(
    SearchResultState state,
    GlobalSearchNotifier notifier,
    bool isDark,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color cardBg,
    Color cardBorder,
  ) {
    if (state.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0B1B22)
                      : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF14303D) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  color: secondaryTextColor,
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'No Results Found',
                style: GoogleFonts.poppins(
                  color: primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We couldn\'t find any match for "${state.query}".\nTry searching for show titles, host names, genres, or keywords.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: secondaryTextColor,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final cat = state.selectedCategory;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      children: [
        // 1. Shows Section
        if ((cat == SearchCategory.all || cat == SearchCategory.shows) &&
            state.shows.isNotEmpty) ...[
          _SectionHeader(
            title: 'SHOWS & PROGRAMS',
            count: state.shows.length,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          ...state.shows.map(
            (show) => _ShowSearchCard(
              show: show,
              isDark: isDark,
              cardBg: cardBg,
              cardBorder: cardBorder,
              onTap: () => context.push('/show_details/${show.id}'),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // 2. Podcasts Section
        if ((cat == SearchCategory.all || cat == SearchCategory.podcasts) &&
            state.podcasts.isNotEmpty) ...[
          _SectionHeader(
            title: 'PODCASTS & EPISODES',
            count: state.podcasts.length,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          ...state.podcasts.map(
            (podcast) => _PodcastSearchCard(
              podcast: podcast,
              isDark: isDark,
              cardBg: cardBg,
              cardBorder: cardBorder,
              onTap: () => context.push('/podcast_details/${podcast.id}'),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // 3. News & Articles
        if ((cat == SearchCategory.all || cat == SearchCategory.news) &&
            state.posts.isNotEmpty) ...[
          _SectionHeader(
            title: 'NEWS & ARTICLES',
            count: state.posts.length,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          ...state.posts.map(
            (post) => _PostSearchCard(
              post: post,
              isDark: isDark,
              cardBg: cardBg,
              cardBorder: cardBorder,
              onTap: () => context.push('/post_details/${post.id}'),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // 4. Events
        if ((cat == SearchCategory.all || cat == SearchCategory.events) &&
            state.events.isNotEmpty) ...[
          _SectionHeader(
            title: 'EVENTS & CONCERTS',
            count: state.events.length,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          ...state.events.map(
            (event) => _EventSearchCard(
              event: event,
              isDark: isDark,
              cardBg: cardBg,
              cardBorder: cardBorder,
              onTap: () => context.push('/event_details/${event.id}'),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // 5. Presenters
        if ((cat == SearchCategory.all || cat == SearchCategory.presenters) &&
            state.presenters.isNotEmpty) ...[
          _SectionHeader(
            title: 'PRESENTERS & DJS',
            count: state.presenters.length,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          ...state.presenters.map(
            (presenter) => _PresenterSearchCard(
              presenter: presenter,
              isDark: isDark,
              cardBg: cardBg,
              cardBorder: cardBorder,
              onTap: () => context.push('/presenter_details/${presenter.id}'),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // 6. Videos
        if ((cat == SearchCategory.all || cat == SearchCategory.videos) &&
            state.videos.isNotEmpty) ...[
          _SectionHeader(
            title: 'VIDEOS & CLIPS',
            count: state.videos.length,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          ...state.videos.map(
            (video) => _VideoSearchCard(
              video: video,
              isDark: isDark,
              cardBg: cardBg,
              cardBorder: cardBorder,
              onTap: () => context.push('/video_details/${video.id}'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool isDark;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: isDark ? const Color(0xFF00A3FF) : const Color(0xFF0B6B82),
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count found',
            style: GoogleFonts.inter(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _BrowseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  const _BrowseCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowSearchCard extends StatelessWidget {
  final ShowModel show;
  final bool isDark;
  final Color cardBg;
  final Color cardBorder;
  final VoidCallback onTap;

  const _ShowSearchCard({
    required this.show,
    required this.isDark,
    required this.cardBg,
    required this.cardBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            show.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 50,
              height: 50,
              color: AppColors.oceanBlue,
              child: const Icon(Icons.mic, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          show.title,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              'Host: ${show.presenter}',
              style: GoogleFonts.inter(
                color: isDark ? Colors.white70 : const Color(0xFF475569),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${show.days} • ${show.airTime}',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF94A3B8),
          size: 22,
        ),
      ),
    );
  }
}

class _PodcastSearchCard extends StatelessWidget {
  final PodcastModel podcast;
  final bool isDark;
  final Color cardBg;
  final Color cardBorder;
  final VoidCallback onTap;

  const _PodcastSearchCard({
    required this.podcast,
    required this.isDark,
    required this.cardBg,
    required this.cardBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            podcast.coverImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 50,
              height: 50,
              color: const Color(0xFF833AB4),
              child: const Icon(Icons.headphones, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          podcast.title,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Host: ${podcast.host} • ${podcast.episodesCount} Episodes',
          style: GoogleFonts.inter(
            color: isDark ? Colors.white70 : const Color(0xFF475569),
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF94A3B8),
          size: 22,
        ),
      ),
    );
  }
}

class _PostSearchCard extends StatelessWidget {
  final PostModel post;
  final bool isDark;
  final Color cardBg;
  final Color cardBorder;
  final VoidCallback onTap;

  const _PostSearchCard({
    required this.post,
    required this.isDark,
    required this.cardBg,
    required this.cardBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            post.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 50,
              height: 50,
              color: const Color(0xFF0B6B82),
              child: const Icon(Icons.newspaper, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          post.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${post.category} • ${post.date}',
          style: GoogleFonts.inter(
            color: isDark ? Colors.white70 : const Color(0xFF475569),
            fontSize: 11.5,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF94A3B8),
          size: 22,
        ),
      ),
    );
  }
}

class _EventSearchCard extends StatelessWidget {
  final EventModel event;
  final bool isDark;
  final Color cardBg;
  final Color cardBorder;
  final VoidCallback onTap;

  const _EventSearchCard({
    required this.event,
    required this.isDark,
    required this.cardBg,
    required this.cardBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            event.bannerImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 50,
              height: 50,
              color: const Color(0xFFE65100),
              child: const Icon(Icons.local_activity, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          event.title,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${event.date} • ${event.location}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: isDark ? Colors.white70 : const Color(0xFF475569),
            fontSize: 11.5,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF94A3B8),
          size: 22,
        ),
      ),
    );
  }
}

class _PresenterSearchCard extends StatelessWidget {
  final PresenterModel presenter;
  final bool isDark;
  final Color cardBg;
  final Color cardBorder;
  final VoidCallback onTap;

  const _PresenterSearchCard({
    required this.presenter,
    required this.isDark,
    required this.cardBg,
    required this.cardBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(presenter.image),
          backgroundColor: const Color(0xFF00BFA5),
        ),
        title: Text(
          presenter.name,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          presenter.showName,
          style: GoogleFonts.inter(
            color: isDark ? Colors.white70 : const Color(0xFF475569),
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF94A3B8),
          size: 22,
        ),
      ),
    );
  }
}

class _VideoSearchCard extends StatelessWidget {
  final VideoModel video;
  final bool isDark;
  final Color cardBg;
  final Color cardBorder;
  final VoidCallback onTap;

  const _VideoSearchCard({
    required this.video,
    required this.isDark,
    required this.cardBg,
    required this.cardBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                video.thumbnailUrl,
                width: 60,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 44,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
        title: Text(
          video.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Duration: ${video.duration} • ${video.views} views',
          style: GoogleFonts.inter(
            color: isDark ? Colors.white70 : const Color(0xFF475569),
            fontSize: 11.5,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF94A3B8),
          size: 22,
        ),
      ),
    );
  }
}
