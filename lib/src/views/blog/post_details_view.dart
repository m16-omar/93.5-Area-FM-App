import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/widgets/mini_player.dart';
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
      backgroundColor: AppColors.backgroundDark,
      appBar: AreaFMAppBar(
        title: 'Article Details',
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () {
              postAsync.whenData((post) => ShareService.shareNews(post.title, post.summary));
            },
          ),
        ],
      ),
      bottomNavigationBar: const MiniPlayerWidget(),
      body: postAsync.when(
        loading: () => const AppLoader(message: 'Loading article...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(postDetailsProvider(id)),
        ),
        data: (post) => SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomNetworkImage(
                  imageUrl: post.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: Text(
                  post.category.toUpperCase(),
                  style: GoogleFonts.bebasNeue(
                    color: AppColors.primary,
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textSecondaryDark),
                  const SizedBox(width: 4),
                  Text(post.author, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryDark)),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textSecondaryDark),
                  const SizedBox(width: 4),
                  Text(post.date, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryDark)),
                ],
              ),
              const Divider(height: 32, color: AppColors.borderDark),
              Text(
                post.content,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.7,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
