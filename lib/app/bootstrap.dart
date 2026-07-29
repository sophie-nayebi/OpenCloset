/// Application bootstrap and dependency injection configuration.
///
/// This module sets up the Riverpod provider container with app-level providers,
/// theme configuration, and preference stubs. All providers are lazy-loaded to
/// ensure efficient initialization.
///
/// ## Provider Categories
///
/// ### Theme Providers
/// - [themeProvider]: Manages application theme state (light/dark/system)
///
/// ### Preference Stubs
/// - [userPreferencesProvider]: Stub provider for user preferences (lazy initialization)
/// - [userSettingsProvider]: Stub provider for user settings (lazy initialization)
///
/// ## Lazy-Loading Pattern
///
/// All providers are lazily initialized through Riverpod's provider system.
/// Riverpod automatically handles lazy-loading and caching.
///
/// ## Usage
///
/// ```dart
/// import 'package:opencloset/app/bootstrap.dart';
///
/// // Access providers through the container
/// final theme = themeProvider.read();
///
/// // Or use watch in a ConsumerWidget:
/// ConsumerWidget(
///   builder: (context, ref) {
///     final theme = ref.watch(themeProvider);
///     // ...
///   },
/// );
/// ```
///
/// ## Architecture
///
/// ```
/// lib/app/
/// ├── bootstrap.dart          (this file - provider registration)
/// ├── app.dart                (MaterialApp configuration)
/// └── theme.dart              (Theme data definitions)
/// ```

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The main theme provider that manages application theme state.
///
/// This provider is responsible for:
/// - Initializing the theme with system preference
/// - Managing theme mode changes
/// - Providing the current color scheme
///
/// ## Usage
///
/// ```dart
/// final theme = themeProvider;
/// theme.read(); // Returns AppThemeState
///
/// // Or use watch in a ConsumerWidget:
/// ConsumerWidget(
///   builder: (context, ref) {
///     final theme = ref.watch(themeProvider);
///     // ...
///   },
/// );
/// ```
final themeProvider = Provider<AppThemeState>((ref) {
  return _createThemeState();
});

/// Theme state class that holds the current theme configuration.
///
/// This class encapsulates all theme-related state and provides a clean API
/// for accessing theme properties.
class AppThemeState {
  /// Creates a new [AppThemeState] instance.
  ///
  /// [isDark] determines whether to use the dark or light theme.
  /// [colorScheme] contains the current color scheme (light or dark).
  /// [themeMode] is the current theme mode (system, light, or dark).
  const AppThemeState({
    required this.isDark,
    required this.colorScheme,
    required this.themeMode,
    required this.lightScheme,
    required this.darkScheme,
  });

  /// Whether dark theme is currently active.
  final bool isDark;

  /// The current color scheme for the application.
  final ColorScheme colorScheme;

  /// The light color scheme.
  final ColorScheme lightScheme;

  /// The dark color scheme.
  final ColorScheme darkScheme;

  /// The current theme mode (system, light, or dark).
  final ThemeMode themeMode;
}

/// Creates the initial theme state.
///
/// This function creates the initial theme state with the system default brightness.
///
/// ## Returns
///
/// An [AppThemeState] instance with:
/// - Default theme mode (system)
/// - Color scheme based on system brightness
AppThemeState _createThemeState() {
  // Use system theme preference by default
  final isDark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  final colorScheme = _createColorScheme(isDark);
  final lightScheme = ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.light,
  );
  final darkScheme = ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  );
  final themeMode = ThemeMode.system;

  return AppThemeState(
    isDark: isDark,
    colorScheme: colorScheme,
    lightScheme: lightScheme,
    darkScheme: darkScheme,
    themeMode: themeMode,
  );
}

/// Creates a color scheme based on the brightness.
ColorScheme _createColorScheme(bool isDark) {
  return ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: isDark ? Brightness.dark : Brightness.light,
  );
}

/// User preferences stub provider.
///
/// This is a lazy-loaded stub provider that will be replaced with real
/// preferences implementation when the database module is ready.
///
/// ## Current Behavior
///
/// Returns a default [UserPreferences] instance with stub values.
/// The provider is lazily initialized through Riverpod's provider system.
///
/// ## Future Implementation
///
/// Should be replaced with:
/// - [SharedPreferences] or similar for local storage
/// - Database integration for persistence
/// - Sync with server for cloud preferences
///
/// ## Example
///
/// ```dart
/// final prefs = userPreferencesProvider;
/// prefs.read(); // Returns UserPreferences
/// ```
final userPreferencesProvider = Provider<UserPreferences>((ref) {
  return _UserPreferencesStub();
});

/// Stub implementation of user preferences.
///
/// This class provides stub values for user preferences until the
/// real implementation is ready.
class UserPreferences {
  /// Creates a new [UserPreferences] instance.
  const UserPreferences({
    this.isDarkMode = false,
    this.fontSize = 16.0,
    this.language = 'en',
    this.notificationsEnabled = true,
  });

  /// Whether dark mode is enabled.
  final bool isDarkMode;

  /// The font size preference.
  final double fontSize;

  /// The preferred language code.
  final String language;

  /// Whether notifications are enabled.
  final bool notificationsEnabled;
}

/// Stub implementation of user preferences using default values.
UserPreferences _UserPreferencesStub() => const UserPreferences();

/// User settings stub provider.
///
/// This is a lazy-loaded stub provider for user settings such as:
/// - App visibility settings
/// - Default views
/// - Sorting preferences
///
/// ## Current Behavior
///
/// Returns a default [UserSettings] instance with stub values.
/// The provider is lazily initialized through Riverpod's provider system.
///
/// ## Future Implementation
///
/// Should be replaced with:
/// - Database integration for persistent settings
/// - Default settings from configuration files
/// - User-specific settings from server sync
///
/// ## Example
///
/// ```dart
/// final settings = userSettingsProvider;
/// settings.read(); // Returns UserSettings
/// ```
final userSettingsProvider = Provider<UserSettings>((ref) {
  return _UserSettingsStub();
});

/// Stub implementation of user settings.
///
/// This class provides stub values for user settings until the
/// real implementation is ready.
class UserSettings {
  /// Creates a new [UserSettings] instance.
  const UserSettings({
    this.sortOrder = 'newest',
    this.defaultView = 'grid',
    this.showPrice = false,
  });

  /// The default sort order for items.
  final String sortOrder;

  /// The default view mode (grid or list).
  final String defaultView;

  /// Whether to show price in the UI.
  final bool showPrice;
}

/// Stub implementation of user settings using default values.
UserSettings _UserSettingsStub() => const UserSettings();
