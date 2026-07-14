import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/location_permission_screen.dart';
import '../features/home/home_screen.dart';
import '../features/search/location_picker_screen.dart';
import '../features/search/route_preference_screen.dart';
import '../features/search/route_results_screen.dart';
import '../features/search/bus_options_screen.dart';
import '../features/search/route_detail_screen.dart';
import '../features/nearby/nearby_stops_screen.dart';
import '../features/nearby/stop_detail_screen.dart';
import '../features/saved/saved_places_screen.dart';
import '../features/profile/profile_screen.dart';
import '../shared/widgets/pill_bottom_nav.dart';
import '../features/system/no_internet_screen.dart';
import '../features/system/error_empty_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/permission',
      builder: (context, state) => const LocationPermissionScreen(),
    ),
    GoRoute(
      path: '/picker',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LocationPickerScreen(),
    ),
    GoRoute(
      path: '/preferences',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return RoutePreferenceScreen(searchData: extra);
      },
    ),
    GoRoute(
      path: '/results',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return RouteResultsScreen(searchData: extra);
      },
    ),
    GoRoute(
      path: '/bus-options',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final route = state.extra as Map<String, dynamic>? ?? {};
        return BusOptionsScreen(route: route);
      },
    ),
    GoRoute(
      path: '/route-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final route = state.extra as Map<String, dynamic>? ?? {};
        return RouteDetailScreen(route: route);
      },
    ),
    GoRoute(
      path: '/stop-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const StopDetailScreen(),
    ),
    GoRoute(
      path: '/no-internet',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final onRetryCallback = state.extra as VoidCallback?;
        return NoInternetScreen(
          onRetry: onRetryCallback ?? () {}, // Falls back to an empty function if null
        );
      },
    ),
    GoRoute(
      path: '/error-empty',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final messageText = extraData?['message'] as String? ?? state.extra as String? ?? 'An error occurred';
        final actionCallback = extraData?['onAction'] as VoidCallback? ?? () {};
        final labelText = extraData?['actionLabel'] as String? ?? 'Retry';
        
        return ErrorEmptyScreen(
          title: extraData?['title'] as String? ?? 'Error',
          message: messageText,
          actionLabel: labelText,
          onAction: actionCallback,
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: Stack(
            children: [
              navigationShell,
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: PillBottomNav(navigationShell: navigationShell),
              ),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/nearby',
              builder: (context, state) => const NearbyStopsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/saved',
              builder: (context, state) => const SavedPlacesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);