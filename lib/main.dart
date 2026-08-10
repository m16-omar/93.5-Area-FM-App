import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'const/app_colors.dart';
import 'const/app_text_styles.dart';
import 'src/routes/app_routes.dart';
import 'src/services/storage_service.dart';
import 'src/controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.initHive();
  runApp(const ProviderScope(child: AreaFMApp()));
}

class AreaFMApp extends ConsumerWidget {
  const AreaFMApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: '93.5 Area FM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surfaceLight,
          error: AppColors.error,
        ),
        textTheme: TextTheme(
          titleLarge: AppTextStyles.headingLarge(color: AppColors.textPrimaryLight),
          titleMedium: AppTextStyles.headingMedium(color: AppColors.textPrimaryLight),
          bodyLarge: AppTextStyles.bodyLarge(color: AppColors.textPrimaryLight),
          bodyMedium: AppTextStyles.bodyMedium(color: AppColors.textPrimaryLight),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surfaceDark,
          error: AppColors.error,
        ),
        textTheme: TextTheme(
          titleLarge: AppTextStyles.headingLarge(color: AppColors.textPrimaryDark),
          titleMedium: AppTextStyles.headingMedium(color: AppColors.textPrimaryDark),
          bodyLarge: AppTextStyles.bodyLarge(color: AppColors.textPrimaryDark),
          bodyMedium: AppTextStyles.bodyMedium(color: AppColors.textPrimaryDark),
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
