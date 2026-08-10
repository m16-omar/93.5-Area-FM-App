import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../providers/team_provider.dart';
import 'widgets/team_member_card.dart';

class TeamView extends ConsumerWidget {
  const TeamView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamMembersProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Station Leadership'),
      body: teamAsync.when(
        loading: () => const AppLoader(message: 'Loading team members...'),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (members) => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: members.length,
          itemBuilder: (context, index) => TeamMemberCardWidget(
            member: members[index],
            onTap: () => context.push('/team_member_details/${members[index].id}'),
          ),
        ),
      ),
    );
  }
}
