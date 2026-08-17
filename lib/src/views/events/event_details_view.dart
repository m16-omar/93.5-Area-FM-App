import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/mini_player.dart';
import '../../../common/helpers/url_helper.dart';
import '../../../const/app_colors.dart';
import '../../providers/events_provider.dart';
import 'widgets/event_banner.dart';

class EventDetailsView extends ConsumerWidget {
  final String id;

  const EventDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailsProvider(id));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: const AreaFMAppBar(title: 'Event Details', showBack: true),
      bottomNavigationBar: const MiniPlayerWidget(),
      body: eventAsync.when(
        loading: () => const AppLoader(message: 'Loading event...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(eventDetailsProvider(id)),
        ),
        data: (event) => SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventBannerWidget(imageUrl: event.bannerImage),
              const SizedBox(height: 20),
              Text(
                event.title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          '${event.date} • ${event.time}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            event.location,
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondaryDark,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'About this Event',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 32),
              if (event.ticketUrl.isNotEmpty)
                AppButton(
                  title: 'Get Tickets Now',
                  icon: Icons.confirmation_number_outlined,
                  onPressed: () => UrlHelper.launchURL(event.ticketUrl),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
