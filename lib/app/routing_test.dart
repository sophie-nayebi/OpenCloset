/// Widget tests for routing functionality.
///
/// These tests verify that routing works correctly in the UI,
/// including navigation between routes and 404 handling.
///
/// Test coverage:
/// - Home route renders correctly
/// - Settings route renders correctly
/// - Unknown routes show 404
/// - Named route navigation works
/// - Router configuration is correct
/// - Deep linking stub exists

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset/shared/routing_test_router.dart';

void main() {
  group('Routing widget tests', () {
    testWidgets('home route renders correctly', (WidgetTester tester) async {
      // Create a fresh router instance using the test router factory
      final router = TestRouter.create();

      // Build the home widget
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // Verify the home screen is displayed
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('settings route renders correctly', (WidgetTester tester) async {
      // Create a fresh router instance with settings as initial location
      final router = TestRouter.create(initialLocation: '/settings');

      // Build the settings widget
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // Verify settings screen is displayed
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('404 route exists and can be accessed', (WidgetTester tester) async {
      // Create a fresh router instance
      final router = TestRouter.create();

      // Build the router starting at home
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // Verify home is displayed initially
      expect(find.text('Home'), findsOneWidget);

      // Navigate to an unknown path which should trigger 404
      // Note: The 404 route is wrapped in Semantics which doesn't affect find.text()
      // The Text is still accessible directly
      router.go('/nonexistent');
      await tester.pumpAndSettle();

      // Verify 404 is displayed for unknown paths
      // The Semantics widget wraps the Text, so we find by the text directly
      expect(find.text('Page Not Found'), findsOneWidget);
    });

    testWidgets('router starts at home route by default', (WidgetTester tester) async {
      final router = TestRouter.create(initialLocation: '/');

      // Build with test router (starts at home by default)
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // Verify home is displayed
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('router can navigate to settings route', (WidgetTester tester) async {
      final router = TestRouter.create(initialLocation: '/');

      // Build with test router (starts at home by default)
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // Verify home is displayed initially
      expect(find.text('Home'), findsOneWidget);

      // Navigate to settings using router.push()
      final settingsLocation = '/settings';
      router.push(settingsLocation);
      await tester.pumpAndSettle();

      // Verify settings is displayed after navigation
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('router supports named navigation', (WidgetTester tester) async {
      final router = TestRouter.create();

      // Build with test router (starts at home by default)
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // Verify home is displayed initially
      expect(find.text('Home'), findsOneWidget);

      // Navigate to settings using context.goNamed()
      router.goNamed('settings');
      await tester.pumpAndSettle();

      // Verify settings is displayed after navigation
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
