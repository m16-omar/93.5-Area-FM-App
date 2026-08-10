import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
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

    return Scaffold(
      appBar: const CustomAppBar(title: 'Presenter Profile'),
      body: presenterAsync.when(
        loading: () => const AppLoader(),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (presenter) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              PresenterHeroWidget(presenter: presenter),
              const SizedBox(height: 12),
              PresenterSocialsWidget(
                instagram: presenter.instagram,
                twitter: presenter.twitter,
                facebook: presenter.facebook,
              ),
              const Divider(height: 32),
              Text(
                presenter.bio,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.6),
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
