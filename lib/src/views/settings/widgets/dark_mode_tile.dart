import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../const/app_colors.dart';
import '../../../providers/settings_provider.dart';

class DarkModeTileWidget extends ConsumerWidget {
  const DarkModeTileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: const Icon(Icons.dark_mode_outlined),
      title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: const Text('Enable sleek dark theme interface', style: TextStyle(fontSize: 12, color: Colors.grey)),
      activeThumbColor: AppColors.primary,
      value: settings.isDarkMode,
      onChanged: (val) => ref.read(settingsNotifierProvider.notifier).toggleTheme(val),
    );
  }
}
