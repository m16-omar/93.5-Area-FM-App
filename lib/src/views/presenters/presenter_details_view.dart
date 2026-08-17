import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/mini_player.dart';
import '../../../const/app_colors.dart';
import '../../providers/presenter_provider.dart';
import 'widgets/presenter_hero.dart';
import 'widgets/presenter_socials.dart';
import 'widgets/presenter_show_card.dart';

class PresenterDetailsView extends ConsumerWidget {
  final String id;

  const PresenterDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenterAsync = ref.watch(presenterDetailsProvider(id));

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AreaFMAppBar(
        title: 'Presenter Profile',
        showBack: true,
        foregroundColor: isDark ? Colors.white : AppColors.textPrimaryLight,
      ),
      bottomNavigationBar: const MiniPlayerWidget(),
      body: presenterAsync.when(
        loading: () => const AppLoader(message: 'Loading profile...'),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(presenterDetailsProvider(id)),
        ),
        data: (presenter) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              PresenterHeroWidget(presenter: presenter),
              const SizedBox(height: 16),
              PresenterSocialsWidget(
                instagram: presenter.instagram,
                twitter: presenter.twitter,
                facebook: presenter.facebook,
              ),
              const Divider(height: 36, color: AppColors.borderDark),
              Text(
                presenter.bio,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 24),
              PresenterShowCardWidget(showName: presenter.showName),
            ],
          ),
        ),
      ),
    );
  }
}
