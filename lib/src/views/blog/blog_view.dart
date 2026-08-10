import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/widgets/app_search_filter.dart';
import '../../providers/blog_provider.dart';
import '../../models/post_model.dart';
import '../drawer/app_drawer.dart';

class BlogView extends ConsumerStatefulWidget {
  const BlogView({super.key});

  @override
  ConsumerState<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends ConsumerState<BlogView> {
  String _selectedCategory = 'All';
  final _categories = ['All', 'Station News', 'Events', 'Interviews', 'Music'];

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(blogPostsProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3),
      body: postsAsync.when(
        loading: () => const AppLoader(message: 'Loading news...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(blogPostsProvider),
        ),
        data: (posts) {
          final filtered = _selectedCategory == 'All'
              ? posts
              : posts.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _BlogHeader(size: size)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: AppFilterChips(
                    filters: _categories,
                    selected: _selectedCategory,
                    onChanged: (v) => setState(() => _selectedCategory = v),
                  ),
                ),
              ),
              // Featured post (first item)
              if (filtered.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: _FeaturedPostCard(
                      post: filtered.first,
                      onTap: () => context.push('/post_details/${filtered.first.id}'),
                    ),
                  ),
                ),
              // Latest heading
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Latest Stories', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      Text('See All', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              // Post list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    if (i == 0 && filtered.isNotEmpty) return const SizedBox.shrink();
                    final post = filtered[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: _PostTile(
                        post: post,
                        onTap: () => context.push('/post_details/${post.id}'),
                      ),
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
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
    return SizedBox(
      height: size.height * 0.26,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -20, top: 0, bottom: 0,
            child: Image.network(
              'https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=400&q=80',
              fit: BoxFit.cover, width: size.width * 0.55,
            ),
          ),
          Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [AppColors.backgroundDark, AppColors.backgroundDark.withValues(alpha: 0.85), Colors.transparent], stops: const [0.0, 0.5, 1.0]))),
          Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.backgroundDark, Colors.transparent, AppColors.backgroundDark], stops: const [0.0, 0.4, 1.0]))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('NEWS &', style: GoogleFonts.bebasNeue(fontSize: 52, color: Colors.white, letterSpacing: 2)),
                  Text('BLOG', style: GoogleFonts.bebasNeue(fontSize: 52, color: AppColors.primary, letterSpacing: 2, height: 0.85)),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: 'Stories from ', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                      TextSpan(text: '93.5 AREA FM.', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              child: CustomNetworkImage(imageUrl: post.image, width: 90, height: 90, fit: BoxFit.cover),
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
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Text(post.category, style: GoogleFonts.inter(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 5),
                    Text(post.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(post.author, style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 10)),
                        const SizedBox(width: 6),
                        Text('·', style: GoogleFonts.inter(color: AppColors.textMutedDark, fontSize: 10)),
                        const SizedBox(width: 6),
                        Text(post.date, style: GoogleFonts.inter(color: AppColors.textMutedDark, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.bookmark_outline_rounded, color: AppColors.textMutedDark, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
