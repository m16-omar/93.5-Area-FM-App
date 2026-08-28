import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/app_colors.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/widgets/app_search_filter.dart';
import '../../providers/charts_provider.dart';
import '../../providers/radio_player_provider.dart';
import '../../models/chart_model.dart';
import '../../models/radio_stream_model.dart';
import '../drawer/app_drawer.dart';

class ChartsView extends ConsumerStatefulWidget {
  const ChartsView({super.key});

  @override
  ConsumerState<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends ConsumerState<ChartsView> {
  String _selectedCategory = 'TOP 10';
  final _categories = ['TOP 10', 'Nigerian Top 10', 'Afrobeats', 'Hip Hop', 'Gospel'];

  @override
  Widget build(BuildContext context) {
    final chartsAsync = ref.watch(topChartsProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3),
      body: chartsAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => const AppLoader(message: 'Loading charts...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(topChartsProvider),
        ),
        data: (charts) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(topChartsProvider);
            await ref.read(topChartsProvider.future);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _ChartsHeader(size: size)),
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
              // Updated time + share row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.update_rounded, size: 16, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          const SizedBox(width: 6),
                          Text(
                            'Updated 2 hours ago',
                            style: GoogleFonts.inter(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.share_outlined, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            'SHARE',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Chart list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final track = charts[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: _ChartTile(
                        track: track,
                        onPlay: () {
                          final radioStream = RadioStreamModel(
                            id: 'chart_${track.rank}',
                            title: track.title,
                            artist: track.artist,
                            showName: 'Top Chart #${track.rank}',
                            coverUrl: track.albumCover,
                            streamUrl: track.audioUrl,
                            isLive: false,
                          );
                          ref.read(audioPlayerServiceProvider).playTrack(radioStream);
                        },
                      ),
                    );
                  },
                  childCount: charts.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartsHeader extends StatelessWidget {
  final Size size;
  const _ChartsHeader({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.28,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -20,
            top: 0,
            bottom: 0,
            child: Image.network(
              'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=400&q=80',
              fit: BoxFit.cover,
              width: size.width * 0.6,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.backgroundDark,
                  AppColors.backgroundDark.withValues(alpha: 0.85),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundDark,
                  Colors.transparent,
                  AppColors.backgroundDark,
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CHARTS',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 42,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'The hottest songs on ',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                      ),
                      TextSpan(
                        text: '93.5 AREA FM.',
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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
    );
  }
}

class _ChartTile extends StatelessWidget {
  final ChartModel track;
  final VoidCallback onPlay;
  const _ChartTile({required this.track, required this.onPlay});

  // Determine position change: positive = up, negative = down, 0 = same
  int get _positionChange {
    final peakPos = int.tryParse(track.peakPosition) ?? track.rank;
    return peakPos - track.rank; // simplified: positive means moved up
  }

  @override
  Widget build(BuildContext context) {
    final isTop3 = track.rank <= 3;
    final change = _positionChange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 52,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.rank.toString().padLeft(2, '0'),
                  style: GoogleFonts.bebasNeue(
                    fontSize: isTop3 ? 32 : 24,
                    color: isTop3 ? AppColors.primary : Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      change > 0
                          ? Icons.arrow_upward_rounded
                          : change < 0
                              ? Icons.arrow_downward_rounded
                              : Icons.remove_rounded,
                      size: 12,
                      color: change > 0
                          ? AppColors.success
                          : change < 0
                              ? AppColors.error
                              : AppColors.textMutedDark,
                    ),
                    Text(
                      change != 0 ? '${change.abs()}' : '-',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: change > 0
                            ? AppColors.success
                            : change < 0
                                ? AppColors.error
                                : AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Album art
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomNetworkImage(
              imageUrl: track.albumCover,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Track info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  track.artist,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Play button + menu
          Row(
            children: [
              GestureDetector(
                onTap: onPlay,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isTop3 ? AppColors.primary : AppColors.navyBlue,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: isTop3 ? AppColors.primary : AppColors.navyBlue,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.more_vert, color: AppColors.textMutedDark, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
