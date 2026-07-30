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
/// final theme = themeProvider.read(); // Returns AppThemeState
///
/// // Or use watch in a ConsumerWidget:
/// ConsumerWidget(
///   builder: (context, ref) {
///     final theme = ref.watch(themeProvider);
///     // ...
///   },
/// );
///
/// // Toggle theme at runtime:
/// ref.read(themeProvider).toggleTheme();
///
/// // Set specific theme mode:
/// ref.read(themeProvider).setThemeMode(ThemeMode.dark);
/// ```

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The theme notifier that manages application theme state.
///
/// This class extends [StateNotifier] to support runtime theme changes.
/// It provides methods to toggle theme mode and set the theme mode.
///
/// ## Usage
///
/// ```dart
/// // In a ConsumerWidget:
/// ConsumerWidget(
///   builder: (context, ref) {
///     final theme = ref.watch(themeProvider);
///     // theme changes when toggleTheme() or setThemeMode() is called
///   },
/// );
///
/// // Toggle theme at runtime:
/// ref.read(themeProvider).toggleTheme();
///
/// // Set specific theme mode:
/// ref.read(themeProvider).setThemeMode(ThemeMode.dark);
/// ```
class AppThemeNotifier extends StateNotifier<AppThemeState> {
  /// Creates a new [AppThemeNotifier] instance.
  ///
  /// [lightScheme] is the light color scheme.
  /// [darkScheme] is the dark color scheme.
  AppThemeNotifier({
    required this.lightScheme,
    required this.darkScheme,
  })  : super(
         AppThemeState(
           isDark: WidgetsBinding.instance
               .platformDispatcher.platformBrightness == Brightness.dark,
           colorScheme: ColorScheme.fromSeed(
               seedColor: const Color(0xFF6750A4),
               brightness:
                   WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
                   ? Brightness.dark
                   : Brightness.light),
           themeMode: ThemeMode.system,
           lightScheme: lightScheme,
           darkScheme: darkScheme,
         ),
       );

  /// The light color scheme.
  final ColorScheme lightScheme;

  /// The dark color scheme.
  final ColorScheme darkScheme;

  /// Whether dark theme is currently active.
  bool get isDark => state.isDark;

  /// The current theme mode (system, light, or dark).
  ThemeMode get themeMode => state.themeMode;

  /// Toggles the theme mode between light and dark.
  ///
  /// If currently in light mode, switches to dark.
  /// If currently in dark mode, switches to light.
  /// Theme mode remains unchanged.
  void toggleTheme() {
    state = AppThemeState(
      isDark: !state.isDark,
      colorScheme: _createColorScheme(!state.isDark),
      themeMode: state.themeMode,
      lightScheme: lightScheme,
      darkScheme: darkScheme,
    );
  }

  /// Sets the theme mode to the specified value.
  ///
  /// Updates the theme mode and recalculates the color scheme accordingly.
  ///
  /// ## Parameters
  ///
  /// - [mode]: The new theme mode (system, light, or dark)
  void setThemeMode(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;
    state = AppThemeState(
      isDark: isDark,
      colorScheme: _createColorScheme(isDark),
      themeMode: mode,
      lightScheme: lightScheme,
      darkScheme: darkScheme,
    );
  }

  /// Creates a color scheme based on the brightness.
  ColorScheme _createColorScheme(bool isDark) {
    return ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
  }
}

/// The main theme provider that manages application theme state.
///
/// This provider uses the [StateNotifier] pattern to support runtime theme changes.
/// It is responsible for:
/// - Initializing the theme with system preference
/// - Managing theme mode changes
/// - Providing the current color scheme
///
/// ## Usage
///
/// ```dart
/// import 'package:opencloset/app/bootstrap.dart';
///
/// // Access providers through the container
/// final theme = themeProvider.read(); // Returns AppThemeState
///
/// // Or use watch in a ConsumerWidget:
/// ConsumerWidget(
///   builder: (context, ref) {
///     final theme = ref.watch(themeProvider);
///     // ...
///   },
/// );
///
/// // Toggle theme at runtime:
/// ref.read(themeProvider).toggleTheme();
///
/// // Set specific theme mode:
/// ref.read(themeProvider).setThemeMode(ThemeMode.dark);
/// ```
final themeProvider = Provider<AppThemeNotifier>((ref) {
  return AppThemeNotifier(
    lightScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    ),
    darkScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    ),
  );
});

/// Theme state class that holds the current theme configuration.
///
/// This class encapsulates all theme-related state and provides a clean API
/// for accessing theme properties.
///
/// ## Properties
///
/// - [isDark]: Whether dark theme is currently active
/// - [colorScheme]: The current color scheme for the application
/// - [lightScheme]: The light color scheme
/// - [darkScheme]: The dark color scheme
/// - [themeMode]: The current theme mode (system, light, or dark)
///
/// ## Usage
///
/// ```dart
/// final theme = ref.watch(themeProvider);
/// theme.isDark; // true or false
/// theme.themeMode; // ThemeMode.light, ThemeMode.dark, or ThemeMode.system
/// ```
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

  /// Creates the appropriate color scheme based on the theme mode.
  ColorScheme get effectiveColorScheme =>
      themeMode == ThemeMode.system
          ? ColorScheme.fromSeed(
               seedColor: const Color(0xFF6750A4),
               brightness: Brightness.light,
             )
          : (themeMode == ThemeMode.dark ? darkScheme : lightScheme);
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
