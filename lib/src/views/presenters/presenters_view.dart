import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/presenter_provider.dart';
import 'widgets/presenter_card.dart';

class PresentersView extends ConsumerWidget {
  const PresentersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presentersAsync = ref.watch(presentersListProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Radio Hosts & Presenters'),
      body: presentersAsync.when(
        loading: () => const AppLoader(message: 'Loading presenters...'),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (presenters) => GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: presenters.length,
          itemBuilder: (context, index) => PresenterCardWidget(
            presenter: presenters[index],
            onTap: () => context.push('/presenter_details/${presenters[index].id}'),
          ),
        ),
      ),
    );
  }
}
