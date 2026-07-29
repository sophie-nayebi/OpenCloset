/// Unit tests for GoRouter configuration.
///
/// These tests verify that the route configuration compiles
/// and has the expected structure.
///
/// Test coverage:
/// - Route configuration compiles
/// - GoRouterNamed helper class exists
/// - Router is properly instantiated

import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset/app/routes.dart';

void main() {
  group('RouterConfig tests', () {
    test('router should be initialized', () {
      expect(router, isNotNull);
    });

    test('router should be an instance of GoRouter', () {
      expect(router.runtimeType.toString(), contains('GoRouter'));
    });

    test('GoRouterNamed home route should exist', () {
      expect(GoRouterNamed.home, equals('/'));
    });

    test('GoRouterNamed settings route should exist', () {
      expect(GoRouterNamed.settings, equals('/settings'));
    });

    test('GoRouterNamed routes should be non-empty', () {
      expect(GoRouterNamed.home.isNotEmpty, isTrue);
      expect(GoRouterNamed.settings.isNotEmpty, isTrue);
    });
  });
}
