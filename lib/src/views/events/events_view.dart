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
import '../../providers/events_provider.dart';
import '../../models/event_model.dart';
import '../drawer/app_drawer.dart';

class EventsView extends ConsumerStatefulWidget {
  const EventsView({super.key});

  @override
  ConsumerState<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends ConsumerState<EventsView> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'This Week', 'This Month', 'Free', 'Ticketed'];

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsListProvider);
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: const AreaFMAppBar(notificationCount: 3),
      body: eventsAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => const AppLoader(message: 'Loading events...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(eventsListProvider),
        ),
        data: (events) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(eventsListProvider);
            await ref.read(eventsListProvider.future);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _EventsHeader(size: size)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: AppFilterChips(
                    filters: _filters,
                    selected: _selectedFilter,
                    onChanged: (v) => setState(() => _selectedFilter = v),
                  ),
                ),
              ),
              // Featured event banner (first event)
              if (events.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: _FeaturedEventBanner(
                      event: events.first,
                      onTap: () => context.push('/event_details/${events.first.id}'),
                    ),
                  ),
                ),
              // Section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Events',
                        style: GoogleFonts.poppins(
                          color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 16, fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${events.length} Events',
                        style: GoogleFonts.inter(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              // Events list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final event = events[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: _EventTile(
                        event: event,
                        onTap: () => context.push('/event_details/${event.id}'),
                      ),
                    );
                  },
                  childCount: events.length,
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

class _EventsHeader extends StatelessWidget {
  final Size size;
  const _EventsHeader({required this.size});

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
              'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=400&q=80',
              fit: BoxFit.cover, width: size.width * 0.55,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft, end: Alignment.centerRight,
                colors: [AppColors.backgroundDark, AppColors.backgroundDark.withValues(alpha: 0.85), Colors.transparent],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [AppColors.backgroundDark, Colors.transparent, AppColors.backgroundDark],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('EVENTS', style: GoogleFonts.bebasNeue(fontSize: 42, color: Colors.white, letterSpacing: 2)),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: 'Raves, concerts & station events — ', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                      TextSpan(text: 'be there!', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
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

class _FeaturedEventBanner extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  const _FeaturedEventBanner({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomNetworkImage(imageUrl: event.bannerImage, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.85)],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            // Featured badge
            Positioned(
              top: 14, left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('FEATURED', style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 12, letterSpacing: 1.5)),
              ),
            ),
            // Ticket button
            Positioned(
              top: 14, right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_activity_outlined, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('Get Tickets', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
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
                    Text(event.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700), maxLines: 2),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(event.date, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on_outlined, size: 13, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Expanded(child: Text(event.location, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
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

class _EventTile extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  const _EventTile({required this.event, required this.onTap});

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
            // Date box
            Container(
              width: 66,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayFromDate(event.date),
                    style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 28, height: 1.0),
                  ),
                  Text(
                    _monthFromDate(event.date),
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            // Thumbnail
            ClipRRect(
              child: CustomNetworkImage(imageUrl: event.bannerImage, width: 70, height: 70, fit: BoxFit.cover),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined, size: 11, color: AppColors.textSecondaryDark),
                        const SizedBox(width: 3),
                        Text(event.time, style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textSecondaryDark),
                        const SizedBox(width: 3),
                        Expanded(child: Text(event.location, style: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Arrow
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded, color: AppColors.textMutedDark),
            ),
          ],
        ),
      ),
    );
  }

  String _dayFromDate(String date) {
    final parts = date.split(' ');
    return parts.length >= 2 ? parts[1].replaceAll(',', '') : '??';
  }

  String _monthFromDate(String date) {
    final parts = date.split(' ');
    return parts.isNotEmpty ? parts[0].substring(0, parts[0].length.clamp(0, 3)).toUpperCase() : 'JAN';
  }
}
