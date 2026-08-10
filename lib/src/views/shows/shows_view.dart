import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/shows_provider.dart';
import 'widgets/show_card.dart';
import 'widgets/schedule_card.dart';

class ShowsView extends ConsumerWidget {
  const ShowsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showsAsync = ref.watch(showsListProvider);
    final schedulesAsync = ref.watch(schedulesListProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Radio Shows & Schedule',
          showBackButton: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Shows'),
              Tab(text: 'Daily Schedule'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            showsAsync.when(
              loading: () => const AppLoader(message: 'Loading shows...'),
              error: (err, stack) => AppErrorWidget(message: err.toString()),
              data: (shows) => GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: shows.length,
                itemBuilder: (context, index) => ShowCardWidget(
                  show: shows[index],
                  onTap: () => context.push('/show_details/${shows[index].id}'),
                ),
              ),
            ),
            schedulesAsync.when(
              loading: () => const AppLoader(message: 'Loading schedule...'),
              error: (err, stack) => AppErrorWidget(message: err.toString()),
              data: (schedules) => ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: schedules.length,
                itemBuilder: (context, index) => ScheduleCardWidget(schedule: schedules[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
