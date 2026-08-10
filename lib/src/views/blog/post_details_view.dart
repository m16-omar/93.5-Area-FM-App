import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../const/app_colors.dart';
import '../../services/share_service.dart';
import '../../providers/blog_provider.dart';

class PostDetailsView extends ConsumerWidget {
  final String id;

  const PostDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailsProvider(id));

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Article Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              postAsync.whenData((post) => ShareService.shareNews(post.title, post.summary));
            },
          ),
        ],
      ),
      body: postAsync.when(
        loading: () => const AppLoader(),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (post) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetworkImage(
                imageUrl: post.image,
                height: 220,
                width: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  post.category.toUpperCase(),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(post.author, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(post.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const Divider(height: 32),
              Text(
                post.content,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
