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
import '../../providers/presenter_provider.dart';
import '../../models/presenter_model.dart';
import '../drawer/app_drawer.dart';

class PresentersView extends ConsumerStatefulWidget {
  const PresentersView({super.key});

  @override
  ConsumerState<PresentersView> createState() => _PresentersViewState();
}

class _PresentersViewState extends ConsumerState<PresentersView> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final _filters = ['All', 'On Air', 'Presenters', 'DJs', 'Producers', 'News Team'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presentersAsync = ref.watch(presentersListProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3),
      body: presentersAsync.when(
        loading: () => const AppLoader(message: 'Loading team...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(presentersListProvider),
        ),
        data: (presenters) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _PresentersHeader(size: size)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Column(
                  children: [
                    AppSearchBar(controller: _searchController, hint: 'Search team members...'),
                    const SizedBox(height: 14),
                    AppFilterChips(
                      filters: _filters,
                      selected: _selectedFilter,
                      onChanged: (v) => setState(() => _selectedFilter = v),
                    ),
                  ],
                ),
              ),
            ),
            // 3-column presenter grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final presenter = presenters[i];
                    return _PresenterGridCard(
                      presenter: presenter,
                      onTap: () => context.push('/presenter_details/${presenter.id}'),
                    );
                  },
                  childCount: presenters.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _PresentersHeader extends StatelessWidget {
  final Size size;
  const _PresentersHeader({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.28,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -20,
            top: 0,
            bottom: 0,
            child: Image.network(
              AppAssets.presenterBigP,
              fit: BoxFit.cover,
              width: size.width * 0.55,
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
                stops: const [0.0, 0.5, 1.0],
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'TEAM',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'MEMBERS',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                      color: AppColors.primary,
                      letterSpacing: 2,
                      height: 0.85,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Meet the amazing voices behind ',
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
          ),
        ],
      ),
    );
  }
}

class _PresenterGridCard extends StatelessWidget {
  final PresenterModel presenter;
  final VoidCallback onTap;
  const _PresenterGridCard({required this.presenter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.navyBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomNetworkImage(
                imageUrl: presenter.image,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
            // ON AIR badge
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.onAirRed.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5, height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'ON AIR',
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 8,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom info
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      presenter.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      presenter.showName,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Social icons row
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _SmallSocialIcon(Icons.camera_alt_outlined),
                        const SizedBox(width: 4),
                        _SmallSocialIcon(Icons.close_rounded),
                        const SizedBox(width: 4),
                        _SmallSocialIcon(Icons.music_note_rounded),
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

class _SmallSocialIcon extends StatelessWidget {
  final IconData icon;
  const _SmallSocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 11),
    );
  }
}
