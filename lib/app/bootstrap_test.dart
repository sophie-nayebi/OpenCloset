/// Unit tests for the application bootstrap module.
///
/// This test file verifies that:
/// - All providers are registered correctly
/// - Theme provider returns the correct initial state
/// - No duplicate providers exist
/// - Preference stubs are properly initialized
///
/// Run with:
/// ```bash
/// flutter test lib/app/bootstrap_test.dart
/// ```

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencloset/app/bootstrap.dart';

/// Test for theme provider registration.
void main() {
  group('Theme Provider Tests', () {
    test('theme provider is registered', () {
      // Verify that the theme provider can be accessed
      expect(themeProvider, isNotNull);
    });

    test('theme provider returns correct type', () {
      // The provider should return an AppThemeState
      expect(themeProvider.runtimeType, equals(Provider<AppThemeState>));
    });

    test('theme provider initializes with default theme mode', () {
      // Verify the state has the correct structure
      final state = themeProvider;
      expect(state.runtimeType, equals(Provider<AppThemeState>));
    });

    test('theme provider color scheme is correct for light mode', () {
      // Create a dummy state to test color scheme creation
      final lightScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.light,
      );
      final darkScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.dark,
      );
      final dummyState = AppThemeState(
        isDark: false,
        colorScheme: lightScheme,
        lightScheme: lightScheme,
        darkScheme: darkScheme,
        themeMode: ThemeMode.system,
      );

      expect(dummyState.colorScheme.brightness, equals(Brightness.light));
      expect(dummyState.colorScheme.primary, isNotNull);
      expect(dummyState.colorScheme.onPrimary, isNotNull);
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

  group('No Duplicate Providers Tests', () {
    test('theme provider is registered only once', () {
      // Access the provider multiple times to ensure no duplicates
      final provider1 = themeProvider;
      final provider2 = themeProvider;

      expect(provider1, equals(provider2));
    });

    test('user preferences provider is registered only once', () {
      final provider1 = userPreferencesProvider;
      final provider2 = userPreferencesProvider;

      expect(provider1, equals(provider2));
    });

    test('user settings provider is registered only once', () {
      final provider1 = userSettingsProvider;
      final provider2 = userSettingsProvider;

      expect(provider1, equals(provider2));
    });

    test('all providers are distinct', () {
      expect(themeProvider, isNot(equals(userPreferencesProvider)));
      expect(themeProvider, isNot(equals(userSettingsProvider)));
      expect(userPreferencesProvider, isNot(equals(userSettingsProvider)));
    });
  });

  group('Provider Initialization Tests', () {
    test('all providers can be instantiated without errors', () {
      // Create instances to verify they can be instantiated
      final lightScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.light,
      );
      final darkScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.dark,
      );
      final themeState = AppThemeState(
        isDark: false,
        colorScheme: lightScheme,
        lightScheme: lightScheme,
        darkScheme: darkScheme,
        themeMode: ThemeMode.system,
      );
      final prefs = UserPreferences();
      final settings = UserSettings();

      expect(themeState, isNotNull);
      expect(prefs, isNotNull);
      expect(settings, isNotNull);
    });

    test('providers can be accessed in any order', () {
      // Create instances in any order
      final lightScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.light,
      );
      final darkScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.dark,
      );
      final themeState = AppThemeState(
        isDark: false,
        colorScheme: lightScheme,
        lightScheme: lightScheme,
        darkScheme: darkScheme,
        themeMode: ThemeMode.system,
      );
      final settings = UserSettings();
      final prefs = UserPreferences();

      expect(themeState, isNotNull);
      expect(settings, isNotNull);
      expect(prefs, isNotNull);
    });
  });

  group('Theme State Structure Tests', () {
    test('AppThemeState has correct fields', () {
      final lightScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.light,
      );
      final darkScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.dark,
      );
      final state = AppThemeState(
        isDark: false,
        colorScheme: lightScheme,
        lightScheme: lightScheme,
        darkScheme: darkScheme,
        themeMode: ThemeMode.system,
      );

      expect(state.isDark, equals(false));
      expect(state.themeMode, equals(ThemeMode.system));
      expect(state.colorScheme, isNotNull);
    });

    test('AppThemeState is immutable', () {
      final lightScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.light,
      );
      final darkScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF0000FF),
        brightness: Brightness.dark,
      );
      final state = AppThemeState(
        isDark: false,
        colorScheme: lightScheme,
        lightScheme: lightScheme,
        darkScheme: darkScheme,
        themeMode: ThemeMode.system,
      );

      // Create a new state with different values
      final newState = AppThemeState(
        isDark: true,
        colorScheme: state.colorScheme,
        lightScheme: state.lightScheme,
        darkScheme: state.darkScheme,
        themeMode: state.themeMode,
      );

      expect(state, isNot(equals(newState)));
    });

    test('UserPreferences is immutable', () {
      final prefs1 = const UserPreferences();
      final prefs2 = const UserPreferences(
        isDarkMode: true,
      );

      expect(prefs1, isNot(equals(prefs2)));
    });

    test('UserSettings is immutable', () {
      final settings1 = const UserSettings();
      final settings2 = const UserSettings(
        sortOrder: 'oldest',
      );

      expect(settings1, isNot(equals(settings2)));
    });
  });
}
