/// Test for theme configuration constants.
///
/// This test ensures that the theme configuration is properly defined
/// and can be used throughout the application.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset/shared/constants/constants.dart';
import 'package:opencloset/shared/constants/theme_config.dart';

void main() {
  group('ThemeConfig', () {
    test('should have correct seed color', () {
      expect(ThemeConfig.seedColor, const Color(0xFF6750A4));
    });

    test('seed color value should be correct', () {
      final seedColor = ThemeConfig.seedColor;
      expect(seedColor.red, equals(103));
      expect(seedColor.green, equals(80));
      expect(seedColor.blue, equals(164));
      expect(seedColor.alpha, equals(255));
    });

    test('should create light color scheme correctly', () {
      final lightScheme = ColorScheme.fromSeed(
        seedColor: ThemeConfig.seedColor,
        brightness: Brightness.light,
      );
      
      expect(lightScheme.primary, isNotNull);
      expect(lightScheme.secondary, isNotNull);
      expect(lightScheme.onPrimary, isNotNull);
    });

    test('should create dark color scheme correctly', () {
      final darkScheme = ColorScheme.fromSeed(
        seedColor: ThemeConfig.seedColor,
        brightness: Brightness.dark,
      );
      
      expect(darkScheme.primary, isNotNull);
      expect(darkScheme.secondary, isNotNull);
      expect(darkScheme.onPrimary, isNotNull);
    });

    test('theme color should be consistent across schemes', () {
      final lightScheme = ColorScheme.fromSeed(
        seedColor: ThemeConfig.seedColor,
        brightness: Brightness.light,
      );
      
      final darkScheme = ColorScheme.fromSeed(
        seedColor: ThemeConfig.seedColor,
        brightness: Brightness.dark,
      );
      
      expect(lightScheme.primary, isNot(equals(darkScheme.primary)));
      expect(lightScheme.secondary, isNot(equals(darkScheme.secondary)));
    });
  });
}
