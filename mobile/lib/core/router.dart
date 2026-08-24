import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/location_permission_screen.dart';
import '../features/home/home_screen.dart';
import '../features/search/location_picker_screen.dart';
import '../features/search/route_results_screen.dart';
import '../features/search/bus_options_screen.dart';
import '../features/search/route_preview_screen.dart';
import '../features/nearby/nearby_stops_screen.dart';
import '../features/nearby/stop_detail_screen.dart';
import '../features/saved/saved_places/screens/saved_places_screen.dart';
import '../features/saved/saved_places/screens/add_location_search_screen.dart';
import '../features/saved/saved_places/screens/map_location_picker_screen.dart';
import '../features/saved/saved_places/screens/save_location_screen.dart';
import '../features/profile/profile_screen.dart';
import '../shared/widgets/pill_bottom_nav.dart';
import '../features/system/no_internet_screen.dart';
import '../features/search/error_empty_screen.dart';
import '../features/profile/language_selection_screen.dart';
import '../features/profile/about_help_screen.dart';
import '../features/saved/saved_places/models/selected_location.dart';
import '../features/saved/saved_places/services/places_service.dart';
import '../features/profile/privacy_policy_screen.dart';
import '../features/profile/contact_support_screen.dart';
import '../features/profile/faqs_screen.dart';
import '../features/profile/terms_of_service_screen.dart';
import '../features/profile/emergency_contacts_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import 'auth/auth_change_notifier.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Routes reachable without an authenticated session.
const _publicRoutes = <String>{
  '/',
  '/onboarding',
  '/permission',
  '/login',
  '/signup',
  '/forgot-password',
};

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  refreshListenable: AuthChangeNotifier.instance,
  redirect: (context, state) {
    final loggedIn = AuthChangeNotifier.instance.isLoggedIn;
    final location = state.matchedLocation;
    final isPublic = _publicRoutes.contains(location);

    // The splash screen decides where to send unauthenticated users first.
    if (location == '/') return null;

    if (!loggedIn && !isPublic) return '/login';

    // Prevent an authenticated user from seeing the auth screens again.
    if (loggedIn &&
        (location == '/login' ||
            location == '/signup' ||
            location == '/forgot-password')) {
      return '/home';
    }
    return null;
  },
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
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/picker',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LocationPickerScreen(),
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
      path: '/nearby-place',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return NearbyStopsScreen(
          originLocation: LatLng(
            (extra['lat'] as num).toDouble(),
            (extra['lng'] as num).toDouble(),
          ),
          originLabel: extra['label'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/route-preview',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return RoutePreviewScreen(
          route: data['route'] as Map<String, dynamic>? ?? {},
          optionGroups: data['optionGroups'] as List<List<dynamic>>?,
        );
      },
    ),
    GoRoute(
  path: '/profile/language',
  parentNavigatorKey: _rootNavigatorKey,
  builder: (context, state) => const LanguageSelectionScreen(),
),
GoRoute(
  path: '/profile/about',
  parentNavigatorKey: _rootNavigatorKey,
  builder: (context, state) => const AboutHelpScreen(),
),
GoRoute(
  path: '/profile/privacy',
  parentNavigatorKey: _rootNavigatorKey,
  builder: (context, state) => const PrivacyPolicyScreen(),
),

GoRoute(
      path: '/faqs',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FAQsScreen(),
    ),
    GoRoute(
      path: '/contact-support',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ContactSupportScreen(),
    ),
    GoRoute(
      path: '/terms-of-service',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TermsOfServiceScreen(),
    ),
    GoRoute(
      path: '/profile/emergency',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EmergencyContactsScreen(),
    ),
    GoRoute(
      path: '/stop-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final stop = state.extra as Map<String, dynamic>? ?? {};
        return StopDetailScreen(stop: stop);
      },
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

    GoRoute(
  path: '/saved/add-location',
  parentNavigatorKey: _rootNavigatorKey,
  builder: (context, state) =>
      const AddLocationSearchScreen(),
),

GoRoute(
  path: '/saved/map-picker',
  parentNavigatorKey: _rootNavigatorKey,
  builder: (context, state) {
    final place = state.extra as PlaceDetails?;
    return MapLocationPickerScreen(
      initialPlace: place,
    );
  },
),

GoRoute(
  path: '/saved/save-location',
  parentNavigatorKey: _rootNavigatorKey,
  builder: (context, state) {
    final location =
        state.extra as SelectedLocation;

    return SaveLocationScreen(
      selectedLocation: location,
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
