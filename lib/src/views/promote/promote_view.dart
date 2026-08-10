import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/helpers/snackbar_helper.dart';
import '../../providers/promote_provider.dart';
import 'widgets/promotion_card.dart';
import 'widgets/promotion_form.dart';

class PromoteView extends ConsumerWidget {
  const PromoteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(promotionPackagesProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Advertise With Us'),
      body: packagesAsync.when(
        loading: () => const AppLoader(message: 'Loading packages...'),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (packages) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Promote Your Brand On Air',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Reach millions of listeners across our radio broadcasts and digital mobile apps.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Column(
                children: packages
                    .map(
                      (pkg) => PromotionCardWidget(
                        package: pkg,
                        onSelect: () {
                          SnackbarHelper.showInfo(context, 'Booking ${pkg.title}...');
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              const PromotionFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
