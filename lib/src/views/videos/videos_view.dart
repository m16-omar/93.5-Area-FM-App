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
import '../../providers/videos_provider.dart';
import '../../models/video_model.dart';
import '../drawer/app_drawer.dart';

class VideosView extends ConsumerStatefulWidget {
  const VideosView({super.key});

  @override
  ConsumerState<VideosView> createState() => _VideosViewState();
}

class _VideosViewState extends ConsumerState<VideosView> {
  String _selectedCategory = 'All';
  final _categories = ['All', 'Interviews', 'Live Sessions', 'Behind the Scenes', 'Music Videos'];

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(videosListProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3),
      body: videosAsync.when(
        loading: () => const AppLoader(message: 'Loading videos...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(videosListProvider),
        ),
        data: (videos) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _VideosHeader(size: size)),
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
            // Featured video (first item, large)
            if (videos.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: _FeaturedVideoCard(
                    video: videos.first,
                    onTap: () => context.push('/video_details/${videos.first.id}'),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('More Videos', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('See All', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            // Remaining videos list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i == 0 && videos.isNotEmpty) return const SizedBox.shrink();
                  final video = videos[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: _VideoTile(
                      video: video,
                      onTap: () => context.push('/video_details/${video.id}'),
                    ),
                  );
                },
                childCount: videos.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _VideosHeader extends StatelessWidget {
  final Size size;
  const _VideosHeader({required this.size});

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
              'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=400&q=80',
              fit: BoxFit.cover, width: size.width * 0.55,
            ),
          ),
          Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [AppColors.backgroundDark, AppColors.backgroundDark.withValues(alpha: 0.85), Colors.transparent], stops: const [0.0, 0.5, 1.0]))),
          Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.backgroundDark, Colors.transparent, AppColors.backgroundDark], stops: const [0.0, 0.4, 1.0]))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('VIDEOS', style: GoogleFonts.bebasNeue(fontSize: 42, color: Colors.white, letterSpacing: 2)),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: 'Studio sessions, interviews and more from ', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                      TextSpan(text: 'Area FM.', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
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

class _FeaturedVideoCard extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;
  const _FeaturedVideoCard({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomNetworkImage(imageUrl: video.thumbnailUrl, fit: BoxFit.cover),
            ),
            // Dark overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.2), Colors.black.withValues(alpha: 0.8)],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
            // Duration badge
            Positioned(
              top: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(video.duration, style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
            // Centre play button
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 2)],
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
              ),
            ),
            // Bottom info
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(video.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700), maxLines: 2),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.visibility_outlined, size: 13, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text('${video.views} views', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                        const SizedBox(width: 12),
                        const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(video.publishDate, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
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

class _VideoTile extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;
  const _VideoTile({required this.video, required this.onTap});

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
            // Thumbnail with play overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                  child: CustomNetworkImage(imageUrl: video.thumbnailUrl, width: 110, height: 76, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                    ),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.9), shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                // Duration tag
                Positioned(
                  bottom: 4, right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(video.duration, style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(video.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.visibility_outlined, size: 11, color: AppColors.textSecondaryDark),
                        const SizedBox(width: 3),
                        Text('${video.views} views', style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 10)),
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today_outlined, size: 11, color: AppColors.textMutedDark),
                        const SizedBox(width: 3),
                        Text(video.publishDate, style: GoogleFonts.inter(color: AppColors.textMutedDark, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.more_vert, color: AppColors.textMutedDark, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
