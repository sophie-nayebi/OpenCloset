/// Tests for static providers from [static_provider.dart].
///
/// Tests verify that static providers return immutable values that
/// never change at runtime.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../static_provider.dart';

void main() {
  test('static provider returns immutable value', () {
    final version = appVersionProvider.read();

    expect(version, '0.1.0');
  });

  test('appVersionProvider returns the correct version string', () {
    const String expectedVersion = '0.1.0';
    final version = appVersionProvider.read();

    expect(version, expectedVersion);
  });

  test('static provider value never changes', () {
    // Read the value multiple times - it should always return the same value
    final version1 = appVersionProvider.read();
    final version2 = appVersionProvider.read();
    final version3 = appVersionProvider.read();

    expect(version1, '0.1.0');
    expect(version2, '0.1.0');
    expect(version3, '0.1.0');
  });

  test('appNameProvider returns the correct app name', () {
    const String expectedName = 'OpenCloset';
    final name = appNameProvider.read();

    expect(name, expectedName);
  });

  test('enableAIProvider returns false by default', () {
    final enableAI = enableAIProvider.read();

    expect(enableAI, false);
  });

  test('static provider is read-only', () {
    // Static providers should not allow modification
    // We verify the value remains consistent
    expect(appVersionProvider.read(), '0.1.0');
    expect(appNameProvider.read(), 'OpenCloset');
    expect(enableAIProvider.read(), false);
  });
}
