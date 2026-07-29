/// Routing configuration using GoRouter.
///
/// This file defines the application's route table, navigation rules,
/// and deep linking configuration.
///
/// Usage:
/// ```dart
/// import 'package:opencloset/app/routes.dart';
///
/// // Navigate to home
/// context.goNamed('home');
///
/// // Navigate to settings
/// context.goNamed('settings');
///
/// // Navigate with deep linking
/// context.go('/wardrobe/items/123');
/// ```

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opencloset/features/home/home.dart';
import 'package:opencloset/features/settings/settings_screen.dart';

/// The GoRouter instance for the application.
///
/// This router instance is created with named routes for navigation,
/// deep linking support, and a fallback 404 handler.
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Home route
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    // Settings route
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // Fallback route - handles unknown routes with 404
    GoRoute(
      name: 'notFound',
      path: '*',
      builder: (context, state) => Scaffold(
        body: Center(
          child: Semantics(
            label: 'Page not found - The requested page does not exist',
            child: const Text('404 — Page Not Found'),
          ),
        ),
      ),
    ),
  ],
  // Deep linking configuration
  // TODO: Implement deep linking handler stub to handle deep links
  // See issue: "Deep linking stub (currently no handlers)"
  // The handler stub will be added here once deep linking is implemented
  debugLogDiagnostics: true,
);

/// Routes helper class for accessing the router instance.
/// This provides a static getter to avoid circular references in tests.
class routes {
  /// The router instance for the application.
  static GoRouter get router => _router;
}

/// Named route helper for navigation.
///
/// Use this to navigate by route name instead of path.
/// ```dart
/// context.goNamed('home');
/// context.goNamed('settings');
/// ```
class GoRouterNamed {
  /// Navigate to the home screen.
  static String get home => '/';

  /// Navigate to the settings screen.
  static String get settings => '/settings';
}
