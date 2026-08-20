import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../views/splash/splash_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/auth/forgot_password_view.dart';
import '../views/home/home_view.dart';
import '../views/blog/blog_view.dart';
import '../views/blog/post_details_view.dart';
import '../views/podcasts/podcasts_view.dart';
import '../views/podcasts/podcast_details_view.dart';
import '../views/shows/shows_view.dart';
import '../views/shows/show_details_view.dart';
import '../views/charts/charts_view.dart';
import '../views/events/events_view.dart';
import '../views/events/event_details_view.dart';
import '../views/team/team_view.dart';
import '../views/team/team_member_details_view.dart';
import '../views/presenters/presenters_view.dart';
import '../views/presenters/presenter_details_view.dart';
import '../views/videos/videos_view.dart';
import '../views/videos/video_details_view.dart';
import '../views/promote/promote_view.dart';
import '../views/contact/contact_view.dart';
import '../views/notifications/notifications_view.dart';
import '../views/settings/settings_view.dart';
import '../views/about/about_view.dart';
import '../views/radio_player/radio_player_view.dart';
import '../views/car_mode/car_mode_view.dart';
import '../../common/widgets/app_bottom_navigation.dart';
import '../../common/widgets/mini_player.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MainShellScaffold extends StatelessWidget {
  final Widget child;

  const MainShellScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayerWidget(),
          AppBottomNavigation(
            currentIndex: _calculateSelectedIndex(context),
            onTap: (index) => _onItemTapped(index, context),
          ),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    return AppBottomNavigation.indexFromLocation(location);
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.go(RouteNames.shows);
        break;
      case 2:
        context.push(RouteNames.radioPlayer);
        break;
      case 3:
        context.go(RouteNames.podcasts);
        break;
      case 4:
        context.go(RouteNames.settings);
        break;
    }
  }
}

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordView(),
    ),
    GoRoute(
      path: RouteNames.radioPlayer,
      builder: (context, state) => const RadioPlayerView(),
    ),
    GoRoute(
      path: RouteNames.carMode,
      builder: (context, state) => const CarModeView(),
    ),
    GoRoute(
      path: '/show_details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        return ShowDetailsView(id: id);
      },
    ),
    GoRoute(
      path: '/podcast_details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        return PodcastDetailsView(id: id);
      },
    ),
    GoRoute(
      path: '/presenter_details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        return PresenterDetailsView(id: id);
      },
    ),
    GoRoute(
      path: '/event_details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        return EventDetailsView(id: id);
      },
    ),
    GoRoute(
      path: '/video_details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        return VideoDetailsView(id: id);
      },
    ),
    GoRoute(
      path: '/post_details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        return PostDetailsView(id: id);
      },
    ),
    GoRoute(
      path: '/team_member/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        return TeamMemberDetailsView(id: id);
      },
    ),
    GoRoute(
      path: RouteNames.contact,
      builder: (context, state) => const ContactView(),
    ),
    GoRoute(
      path: RouteNames.notifications,
      builder: (context, state) => const NotificationsView(),
    ),
    GoRoute(
      path: RouteNames.promote,
      builder: (context, state) => const PromoteView(),
    ),
    GoRoute(
      path: RouteNames.about,
      builder: (context, state) => const AboutView(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShellScaffold(child: child),
      routes: [
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: RouteNames.shows,
          builder: (context, state) => const ShowsView(),
        ),
        GoRoute(
          path: RouteNames.podcasts,
          builder: (context, state) => const PodcastsView(),
        ),
        GoRoute(
          path: RouteNames.videos,
          builder: (context, state) => const VideosView(),
        ),
        GoRoute(
          path: RouteNames.charts,
          builder: (context, state) => const ChartsView(),
        ),
        GoRoute(
          path: RouteNames.blog,
          builder: (context, state) => const BlogView(),
        ),
        GoRoute(
          path: RouteNames.events,
          builder: (context, state) => const EventsView(),
        ),
        GoRoute(
          path: RouteNames.presenters,
          builder: (context, state) => const PresentersView(),
        ),
        GoRoute(
          path: RouteNames.team,
          builder: (context, state) => const TeamView(),
        ),
        GoRoute(
          path: RouteNames.settings,
          builder: (context, state) => const SettingsView(),
        ),
      ],
    ),
  ],
);
