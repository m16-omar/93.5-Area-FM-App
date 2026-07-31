import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'services/audio_service.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AreaFMApp());
}

class AreaFMApp extends StatefulWidget {
  const AreaFMApp({super.key});

  @override
  State<AreaFMApp> createState() => _AreaFMAppState();
}

class _AreaFMAppState extends State<AreaFMApp> {
  final ValueNotifier<bool> _isDarkModeNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _isDarkModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AudioPlayerService>(
          create: (_) => AudioPlayerService(),
        ),
      ],
      child: ValueListenableBuilder<bool>(
        valueListenable: _isDarkModeNotifier,
        builder: (context, isDark, child) {
          return MaterialApp(
            title: '93.5 Area FM',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: MainNavigationScreen(isDarkModeNotifier: _isDarkModeNotifier),
          );
        },
      ),
    );
  }
}
