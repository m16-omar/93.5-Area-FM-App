import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/blog_provider.dart';
import 'widgets/category_filter.dart';
import 'widgets/featured_post.dart';
import 'widgets/post_card.dart';

class BlogView extends ConsumerStatefulWidget {
  const BlogView({super.key});

  @override
  ConsumerState<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends ConsumerState<BlogView> {
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Station News', 'Events', 'Interviews', 'Music'];

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(blogPostsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'News & Blog', showBackButton: false),
      body: postsAsync.when(
        loading: () => const AppLoader(message: 'Loading news...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(blogPostsProvider),
        ),
        data: (posts) {
          final filteredPosts = _selectedCategory == 'All'
              ? posts
              : posts.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryFilterWidget(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onSelected: (cat) => setState(() => _selectedCategory = cat),
                ),
                const SizedBox(height: 16),
                if (posts.isNotEmpty) ...[
                  FeaturedPostWidget(
                    post: posts.first,
                    onTap: () => context.push('/post_details/${posts.first.id}'),
                  ),
                  const SizedBox(height: 20),
                ],
                const Text(
                  'Recent News',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Column(
                  children: filteredPosts
                      .map(
                        (post) => PostCardWidget(
                          post: post,
                          onTap: () => context.push('/post_details/${post.id}'),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
