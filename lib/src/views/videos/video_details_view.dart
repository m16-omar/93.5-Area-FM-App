import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/mini_player.dart';
import '../../../common/helpers/url_helper.dart';
import '../../../const/app_colors.dart';
import '../../providers/videos_provider.dart';
import 'widgets/video_player.dart';

class VideoDetailsView extends ConsumerWidget {
  final String id;

  const VideoDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(videoDetailsProvider(id));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: const AreaFMAppBar(title: 'Watch Video', showBack: true),
      bottomNavigationBar: const MiniPlayerWidget(),
      body: videoAsync.when(
        loading: () => const AppLoader(message: 'Loading video...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(videoDetailsProvider(id)),
        ),
        data: (video) => SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoPlayerWidget(
                thumbnailUrl: video.thumbnailUrl,
                onPlay: () => UrlHelper.launchURL(video.videoUrl),
              ),
              const SizedBox(height: 20),
              Text(
                video.title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.visibility_outlined, size: 14, color: subTextColor),
                  const SizedBox(width: 4),
                  Text('${video.views} views', style: GoogleFonts.inter(fontSize: 13, color: subTextColor)),
                  const SizedBox(width: 16),
                  Icon(Icons.calendar_today_outlined, size: 13, color: subTextColor),
                  const SizedBox(width: 4),
                  Text(video.publishDate, style: GoogleFonts.inter(fontSize: 13, color: subTextColor)),
                ],
              ),
              Divider(height: 32, color: borderColor),
              Text(
                'Description',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                video.description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
