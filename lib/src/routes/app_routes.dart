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
import '../views/support/support_view.dart';
import '../views/radio_player/radio_player_view.dart';
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
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/radio_player')) return 1;
    if (location.startsWith('/shows')) return 2;
    if (location.startsWith('/podcasts')) return 3;
    if (location.startsWith('/blog') || location.startsWith('/news')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.push(RouteNames.radioPlayer);
        break;
      case 2:
        context.go(RouteNames.shows);
        break;
      case 3:
        context.go(RouteNames.podcasts);
        break;
      case 4:
        context.go(RouteNames.blog);
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
    ShellRoute(
      builder: (context, state, child) => MainShellScaffold(child: child),
      routes: [
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: RouteNames.blog,
          builder: (context, state) => const BlogView(),
        ),
        GoRoute(
          path: '${RouteNames.postDetails}/:id',
          builder: (context, state) => PostDetailsView(id: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: RouteNames.podcasts,
          builder: (context, state) => const PodcastsView(),
        ),
        GoRoute(
          path: '${RouteNames.podcastDetails}/:id',
          builder: (context, state) => PodcastDetailsView(id: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: RouteNames.shows,
          builder: (context, state) => const ShowsView(),
        ),
        GoRoute(
          path: '${RouteNames.showDetails}/:id',
          builder: (context, state) => ShowDetailsView(id: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: RouteNames.charts,
          builder: (context, state) => const ChartsView(),
        ),
        GoRoute(
          path: RouteNames.events,
          builder: (context, state) => const EventsView(),
        ),
        GoRoute(
          path: '${RouteNames.eventDetails}/:id',
          builder: (context, state) => EventDetailsView(id: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: RouteNames.team,
          builder: (context, state) => const TeamView(),
        ),
        GoRoute(
          path: '${RouteNames.teamMemberDetails}/:id',
          builder: (context, state) => TeamMemberDetailsView(id: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: RouteNames.presenters,
          builder: (context, state) => const PresentersView(),
        ),
        GoRoute(
          path: '${RouteNames.presenterDetails}/:id',
          builder: (context, state) => PresenterDetailsView(id: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: RouteNames.videos,
          builder: (context, state) => const VideosView(),
        ),
        GoRoute(
          path: '${RouteNames.videoDetails}/:id',
          builder: (context, state) => VideoDetailsView(id: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: RouteNames.promote,
          builder: (context, state) => const PromoteView(),
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
          path: RouteNames.settings,
          builder: (context, state) => const SettingsView(),
        ),
        GoRoute(
          path: RouteNames.support,
          builder: (context, state) => const SupportView(),
        ),
      ],
    ),
  ],
);
