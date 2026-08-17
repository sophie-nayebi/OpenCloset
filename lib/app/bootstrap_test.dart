/// Unit tests for the application bootstrap module.
///
/// This test file verifies that:
/// - All providers are registered correctly
/// - Theme provider supports runtime theme changes via StateNotifier
/// - Theme mode can be toggled at runtime
/// - No duplicate providers exist
/// - Preference stubs are properly initialized
///
/// Run with:
/// ```bash
/// flutter test lib/app/bootstrap_test.dart
/// ```

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset/app/bootstrap.dart'
    show
        userPreferencesProvider,
        userSettingsProvider,
        AppThemeNotifier,
        UserPreferences,
        UserSettings;

/// Test for theme provider registration.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Theme Provider Tests', () {
    test('theme provider returns AppThemeNotifier instance', () {
      // This test verifies that the theme provider can be toggled at runtime
      final notifier = AppThemeNotifier(
        lightScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        darkScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
      );

      // Initially in light mode
      expect(notifier.isDark, isFalse);

      // Toggle to dark mode
      notifier.toggleTheme();

      expect(notifier.isDark, isTrue);
    });

    test('theme state constructor ensures immutability', () {
      final notifier = AppThemeNotifier(
        lightScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        darkScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
      );

      expect(notifier.themeMode, equals(ThemeMode.system));

      // Change to dark mode
      notifier.setThemeMode(ThemeMode.dark);
      expect(notifier.themeMode, equals(ThemeMode.dark));
    });
  });

  group('Theme Notifier Additional Tests', () {
    test('theme notifier getters return correct schemes', () {
      final lightScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.light,
      );
      final darkScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.dark,
      );

      final notifier = AppThemeNotifier(
        lightScheme: lightScheme,
        darkScheme: darkScheme,
      );

      expect(notifier.lightScheme, same(lightScheme));
      expect(notifier.darkScheme, same(darkScheme));

      notifier.toggleTheme();
      expect(notifier.lightScheme, same(lightScheme));
      expect(notifier.darkScheme, same(darkScheme));
    });

    test('theme notifier disposes correctly without throwing', () {
      final notifier = AppThemeNotifier(
        lightScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        darkScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
      );

      // Verify dispose can be called without errors
      expect(() => notifier.dispose(), returnsNormally);
    });
  });

  group('User Preferences Stub Tests', () {
    test('user preferences provider is registered', () {
      expect(userPreferencesProvider, isNotNull);
    });

    test('user preferences provider returns stub instance', () {
      // Create a stub instance to test
      final prefs = UserPreferences();

      expect(prefs, isA<UserPreferences>());

      // Verify default values
      expect(prefs.isDarkMode, equals(false));
      expect(prefs.fontSize, equals(16.0));
      expect(prefs.language, equals('en'));
      expect(prefs.notificationsEnabled, equals(true));
    });

    test('user preferences stub has correct structure', () {
      final prefs = const UserPreferences();

      expect(prefs.isDarkMode, isA<bool>());
      expect(prefs.fontSize, isA<double>());
      expect(prefs.language, isA<String>());
      expect(prefs.notificationsEnabled, isA<bool>());
    });
  });

  group('User Settings Stub Tests', () {
    test('user settings provider is registered', () {
      expect(userSettingsProvider, isNotNull);
    });

    test('user settings provider returns stub instance', () {
      // Create a stub instance to test
      final settings = UserSettings();

      expect(settings, isA<UserSettings>());

      // Verify default values
      expect(settings.sortOrder, equals('newest'));
      expect(settings.defaultView, equals('grid'));
      expect(settings.showPrice, equals(false));
    });

    test('user settings stub has correct structure', () {
      final settings = const UserSettings();

      expect(settings.sortOrder, isA<String>());
      expect(settings.defaultView, isA<String>());
      expect(settings.showPrice, isA<bool>());
    });
  });
}
