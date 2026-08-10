import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/widgets/app_loader.dart';
import '../../../common/widgets/app_error.dart';
import '../../../common/widgets/network_image.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/helpers/url_helper.dart';
import '../../../const/app_colors.dart';
import '../../providers/team_provider.dart';

class TeamMemberDetailsView extends ConsumerWidget {
  final String id;

  const TeamMemberDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(teamMemberDetailsProvider(id));

    return Scaffold(
      appBar: const CustomAppBar(title: 'Executive Profile'),
      body: memberAsync.when(
        loading: () => const AppLoader(),
        error: (err, stack) => AppErrorWidget(message: err.toString()),
        data: (member) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CustomNetworkImage(
                imageUrl: member.image,
                width: 120,
                height: 120,
                borderRadius: BorderRadius.circular(60),
              ),
              const SizedBox(height: 16),
              Text(
                member.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                member.role,
                style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
              const Divider(height: 32),
              Text(
                member.bio,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 32),
              if (member.email.isNotEmpty)
                AppButton(
                  title: 'Contact ${member.name.split(' ').first}',
                  icon: Icons.email_outlined,
                  onPressed: () => UrlHelper.launchEmail(member.email),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
