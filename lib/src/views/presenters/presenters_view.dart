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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PresenterModel> _filterPresenters(List<PresenterModel> presenters) {
    return presenters.where((p) {
      // Category filter
      bool matchesCategory = true;
      if (_selectedFilter == 'On Air') {
        matchesCategory = p.isOnAir || p.category == 'On Air';
      } else if (_selectedFilter != 'All') {
        matchesCategory = p.category.toLowerCase() == _selectedFilter.toLowerCase();
      }

      // Search query filter
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        matchesSearch = p.name.toLowerCase().contains(_searchQuery) ||
            p.showName.toLowerCase().contains(_searchQuery) ||
            p.timeSlot.toLowerCase().contains(_searchQuery);
      }

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final presentersAsync = ref.watch(presentersListProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF030D18) : AppColors.backgroundLight,
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(
        showBack: true,
        showNotification: true,
        notificationCount: 1,
      ),
      body: presentersAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => const AppLoader(message: 'Loading team...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(presentersListProvider),
        ),
        data: (presenters) {
          final filteredList = _filterPresenters(presenters);

          return RefreshIndicator(
            color: const Color(0xFFFF5500),
            onRefresh: () async {
              ref.invalidate(presentersListProvider);
              await ref.read(presentersListProvider.future);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // 1. Hero Header with Mic & Neon Soundwave
                SliverToBoxAdapter(child: _PresentersHeader(size: size)),

                // 2. Search Bar & Filter Buttons
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                    child: Column(
                      children: [
                        // Search Row with Filter Button
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0C1929),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: const Color(0xFF162942),
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search team members...',
                                    hintStyle: GoogleFonts.inter(
                                      color: const Color(0xFF64748B),
                                      fontSize: 13,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF64748B),
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0052FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.tune_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Filter Chips Row
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filters.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 8),
                            itemBuilder: (context, i) {
                              final filter = _filters[i];
                              final isSelected = filter == _selectedFilter;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedFilter = filter),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF0052FF) : const Color(0xFF0C1929),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF0052FF) : const Color(0xFF162942),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        filter,
                                        style: GoogleFonts.inter(
                                          color: isSelected ? Colors.white : Colors.white70,
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        ),
                                      ),
                                      if (filter == 'On Air' && !isSelected) ...[
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFF5500),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Team 3-Column Grid
                if (filteredList.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No team members found',
                          style: GoogleFonts.inter(color: Colors.white54, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.58,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final presenter = filteredList[i];
                          return _PresenterGridCard(
                            presenter: presenter,
                            onTap: () => context.push('/presenter_details/${presenter.id}'),
                          );
                        },
                        childCount: filteredList.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PresentersHeader extends StatelessWidget {
  final Size size;
  const _PresentersHeader({required this.size});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      height: topPadding + 155,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF020912),
            Color(0xFF030D18),
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Glowing soundwave equalizer bars behind the mic
          Positioned(
            right: 15,
            top: topPadding + 20,
            bottom: 10,
            width: size.width * 0.52,
            child: const _SoundwaveGraphic(),
          ),

          // Studio Microphone Graphic with 93.5 Area FM Pop Filter
          Positioned(
            right: 0,
            top: topPadding + 5,
            bottom: 0,
            width: size.width * 0.48,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                  ],
                  stops: [0.0, 0.35],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                AppAssets.studioMicTransparent,
                fit: BoxFit.contain,
                alignment: Alignment.centerRight,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    AppAssets.studioMicOnly,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                  );
                },
              ),
            ),
          ),

          // Left-side Fade Gradient so text remains crisp and readable
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFF030D18),
                  const Color(0xFF030D18).withValues(alpha: 0.85),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 0.85],
              ),
            ),
          ),

          // Left Header Text
          Positioned(
            left: 16,
            top: topPadding + 44,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TEAM',
                  style: GoogleFonts.outfit(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    height: 1.0,
                  ),
                ),
                Text(
                  'MEMBERS',
                  style: GoogleFonts.outfit(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFFFF5500),
                    letterSpacing: 1.5,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Meet the amazing voices behind',
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '93.5 ',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: 'AREA FM.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFF5500),
                          fontSize: 12.5,
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
    );
  }
}

class _SoundwaveGraphic extends StatelessWidget {
  const _SoundwaveGraphic();

  @override
  Widget build(BuildContext context) {
    const barHeights = [
      0.25, 0.45, 0.70, 0.40, 0.85, 0.60, 0.95, 0.75, 0.50, 0.80, 0.65, 0.90, 0.40, 0.70, 0.30, 0.60, 0.20
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: barHeights.map((h) {
        return Container(
          width: 2.5,
          height: 90 * h,
          decoration: BoxDecoration(
            color: const Color(0xFF0077FF).withValues(alpha: 0.35 + (h * 0.45)),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00B4FF).withValues(alpha: 0.3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      }).toList(),
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
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: presenter.gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Presenter portrait
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 35,
                child: CustomNetworkImage(
                  imageUrl: presenter.image,
                  fit: BoxFit.cover,
                ),
              ),

              // Bottom gradient shadow for readable text overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.95),
                    ],
                    stops: const [0.3, 0.55, 0.75, 1.0],
                  ),
                ),
              ),

              // ON AIR Badge
              if (presenter.isOnAir)
                Positioned(
                  top: 7,
                  left: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4.5,
                          height: 4.5,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5500),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'ON AIR',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Bottom Info and Social Links
              Positioned(
                left: 6,
                right: 6,
                bottom: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      presenter.name,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      presenter.showName,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      presenter.timeSlot,
                      style: GoogleFonts.inter(
                        color: presenter.accentColor,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SocialIconButton(
                          icon: Icons.camera_alt_outlined,
                          onTap: () {},
                        ),
                        _SocialIconButton(
                          isX: true,
                          onTap: () {},
                        ),
                        _SocialIconButton(
                          icon: Icons.music_note_rounded,
                          onTap: () {},
                        ),
                      ],
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

class _SocialIconButton extends StatelessWidget {
  final IconData? icon;
  final bool isX;
  final VoidCallback onTap;

  const _SocialIconButton({
    this.icon,
    this.isX = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 0.7,
          ),
        ),
        alignment: Alignment.center,
        child: isX
            ? const Text(
                '𝕏',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              )
            : Icon(
                icon,
                color: Colors.white,
                size: 12,
              ),
      ),
    );
  }
}
