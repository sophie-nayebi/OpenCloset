/// Shared test router factory for routing tests.
///
/// This utility provides a consistent GoRouter configuration for all tests,
/// eliminating duplication and ensuring all tests use the same structure.
///
/// Usage:
/// ```dart
/// import 'package:opencloset/shared/routing_test_router.dart';
///
/// final testRouter = TestRouter.create();
/// ```
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opencloset/features/home/home.dart';
import 'package:opencloset/features/settings/settings_screen.dart';

/// Test router instance with a fresh configuration.
///
/// Each call creates a new GoRouter instance with the standard test routes.
/// This ensures tests don't interfere with each other and have consistent
/// behavior across different test runs.
class TestRouter {
  /// Creates a new test router instance.
  ///
  /// Returns a fresh GoRouter configured with standard test routes:
  /// - Home route at '/'
  /// - Settings route at '/settings'
  /// - 404 fallback route at '*'
  ///
  /// [initialLocation] - Optional initial route location. If not provided, defaults to '/'.
  static GoRouter create({String? initialLocation}) {
    return GoRouter(
      initialLocation: initialLocation ?? '/',
      routes: [
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
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
      // Set to false to avoid unnecessary diagnostics in tests
      debugLogDiagnostics: false,
    );
  }
}
