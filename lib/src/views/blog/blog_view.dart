import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../const/app_assets.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/widgets/app_search_filter.dart';
import '../../providers/blog_provider.dart';
import '../../repositories/blog_repository.dart';
import '../../models/post_model.dart';
import '../drawer/app_drawer.dart';

class BlogView extends ConsumerStatefulWidget {
  const BlogView({super.key});

  @override
  ConsumerState<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends ConsumerState<BlogView> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(blogPostsProvider);
    final categoriesAsync = ref.watch(blogCategoriesProvider);
    final rawCategories = categoriesAsync.asData?.value ?? BlogRepository.defaultCategories;
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      extendBodyBehindAppBar: false,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3),
      body: postsAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => const AppLoader(message: 'Loading news...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () {
            ref.invalidate(blogPostsProvider);
            ref.invalidate(blogCategoriesProvider);
          },
        ),
        data: (posts) {
          // Collect and merge all available categories (latest first)
          final Set<String> categorySet = {};
          for (final c in rawCategories) {
            if (c != 'All' && c.trim().isNotEmpty) {
              categorySet.add(c.trim());
            }
          }
          for (final p in posts) {
            if (p.category.trim().isNotEmpty) {
              categorySet.add(p.category.trim());
            }
          }
          final categories = ['All', ...categorySet];

          // Sort posts latest first
          final sortedPosts = List<PostModel>.from(posts)
            ..sort((a, b) {
              final idA = int.tryParse(a.id) ?? 0;
              final idB = int.tryParse(b.id) ?? 0;
              return idB.compareTo(idA);
            });

          final filtered = _selectedCategory == 'All'
              ? sortedPosts
              : sortedPosts
                  .where((p) =>
                      p.category.toLowerCase().trim() ==
                      _selectedCategory.toLowerCase().trim())
                  .toList();

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(blogPostsProvider);
              ref.invalidate(blogCategoriesProvider);
              await Future.wait([
                ref.read(blogPostsProvider.future),
                ref.read(blogCategoriesProvider.future),
              ]);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _BlogHeader(size: size)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: AppFilterChips(
                      filters: categories,
                      selected: _selectedCategory,
                      onChanged: (v) => setState(() => _selectedCategory = v),
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.newspaper_rounded,
                              size: 44,
                              color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No stories in "$_selectedCategory" yet',
                              style: GoogleFonts.poppins(
                                color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () => setState(() => _selectedCategory = 'All'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: Text(
                                'View All Stories',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _FeaturedPostCard(
                        post: filtered.first,
                        onTap: () => context.push('/post_details/${filtered.first.id}'),
                      ),
                    ),
                  ),
                  if (filtered.length > 1) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCategory == 'All'
                                  ? 'Latest News'
                                  : 'More in $_selectedCategory',
                              style: GoogleFonts.poppins(
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (_selectedCategory != 'All')
                              GestureDetector(
                                onTap: () => setState(() => _selectedCategory = 'All'),
                                child: Text(
                                  'See All',
                                  style: GoogleFonts.inter(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final post = filtered[i + 1];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                            child: _PostTile(
                              post: post,
                              onTap: () => context.push('/post_details/${post.id}'),
                            ),
                          );
                        },
                        childCount: filtered.length - 1,
                      ),
                    ),
                  ],
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BlogHeader extends StatelessWidget {
  final Size size;
  const _BlogHeader({required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF04181E),
              Color(0xFF085264),
              Color(0xFF0B6B82),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF085264).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Studio Mic Artwork with smooth fade mask on left edge
              Positioned(
                right: 0,
                top: -10,
                bottom: -10,
                width: size.width * 0.55,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.transparent, Colors.white],
                      stops: [0.0, 0.35],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    AppAssets.studioMicOnly,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),
              ),
              // Smooth Left Gradient for crisp text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFF085264),
                        const Color(0xFF085264).withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 0.85],
                    ),
                  ),
                ),
              ),
              // NEWS & BLOG Header Content Column
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NEWS & BLOG',
                      style: GoogleFonts.outfit(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Stories & updates from\n',
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.5),
                          ),
                          TextSpan(
                            text: '93.5 AREA FM.',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }
}

class _FeaturedPostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;
  const _FeaturedPostCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomNetworkImage(imageUrl: post.image, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.05), Colors.black.withValues(alpha: 0.85)],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 14, left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                child: Text(post.category.toUpperCase(), style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 12, letterSpacing: 1.5)),
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700), maxLines: 2),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 13, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(post.author, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time_outlined, size: 13, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(post.date, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;
  const _PostTile({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? AppColors.borderDark.withValues(alpha: 0.5)
                : const Color(0xFFE2E8F0),
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: CustomNetworkImage(
                imageUrl: post.image,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        post.category,
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      post.title,
                      style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          post.author,
                          style: GoogleFonts.inter(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '·',
                          style: GoogleFonts.inter(
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textSecondaryLight,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          post.date,
                          style: GoogleFonts.inter(
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textSecondaryLight,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.bookmark_outline_rounded,
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textSecondaryLight,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
