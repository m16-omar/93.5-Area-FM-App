import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/live_radio/presentation/screens/live_radio_screen.dart';
import '../../features/shows/presentation/screens/shows_screen.dart';
import '../../features/podcasts/presentation/screens/podcasts_screen.dart';
import '../../features/presenters/presentation/screens/presenters_screen.dart';
import '../../features/news/presentation/screens/news_screen.dart';
import '../../features/videos/presentation/screens/videos_screen.dart';
import '../../features/events/presentation/screens/events_screen.dart';
import '../../features/gallery/presentation/screens/gallery_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/about/presentation/screens/about_screen.dart';
import '../../features/home/presentation/widgets/main_shell_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainShellScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/live_radio',
          name: 'live_radio',
          builder: (context, state) => const LiveRadioScreen(),
        ),
        GoRoute(
          path: '/shows',
          name: 'shows',
          builder: (context, state) => const ShowsScreen(),
        ),
        GoRoute(
          path: '/podcasts',
          name: 'podcasts',
          builder: (context, state) => const PodcastsScreen(),
        ),
        GoRoute(
          path: '/presenters',
          name: 'presenters',
          builder: (context, state) => const PresentersScreen(),
        ),
        GoRoute(
          path: '/news',
          name: 'news',
          builder: (context, state) => const NewsScreen(),
        ),
        GoRoute(
          path: '/videos',
          name: 'videos',
          builder: (context, state) => const VideosScreen(),
        ),
        GoRoute(
          path: '/events',
          name: 'events',
          builder: (context, state) => const EventsScreen(),
        ),
        GoRoute(
          path: '/gallery',
          name: 'gallery',
          builder: (context, state) => const GalleryScreen(),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          builder: (context, state) => const AboutScreen(),
        ),
      ],
    ),
  ],
);
