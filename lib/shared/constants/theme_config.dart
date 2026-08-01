/// Theme configuration constants.
///
/// This class centralizes all theme-related configuration values
/// including seed colors and provides helper methods for creating
/// color schemes.
///
/// Usage:
/// ```dart
/// import 'package:opencloset/shared/constants/theme_config.dart';
///
/// final lightScheme = ColorScheme.fromSeed(
///   seedColor: ThemeConfig.seedColor,
///   brightness: Brightness.light,
/// );
/// ```

import 'package:flutter/material.dart';

/// Theme configuration constants.
///
/// This class centralizes all theme-related configuration values
/// including seed colors to avoid duplication throughout the codebase.
///
/// ## Usage
///
/// ```dart
/// // Create color schemes
/// final lightScheme = ColorScheme.fromSeed(
///   seedColor: ThemeConfig.seedColor,
///   brightness: Brightness.light,
/// );
///
/// final darkScheme = ColorScheme.fromSeed(
///   seedColor: ThemeConfig.seedColor,
///   brightness: Brightness.dark,
/// );
///
/// // Use in ThemeData
/// ThemeData(
///   colorScheme: ThemeConfig.lightScheme,
/// );
/// ```
class ThemeConfig {
  /// The seed color used to generate Material 3 color schemes.
  ///
  /// This color forms the basis for the entire color scheme
  /// and determines the primary colors used throughout the application.
  ///
  /// The value `0xFF6750A4` was chosen for its pleasing appearance
  /// in both light and dark modes.
  static const Color seedColor = Color(0xFF6750A4);

  /// Creates a light color scheme using the configured seed color.
  ///
  /// This method provides a convenient way to create the light
  /// color scheme without having to specify the seed color each time.
  static final lightScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  /// Creates a dark color scheme using the configured seed color.
  ///
  /// This method provides a convenient way to create the dark
  /// color scheme without having to specify the seed color each time.
  static final darkScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

  /// Gets the appropriate color scheme based on the theme mode.
  ///
  /// Returns the [darkScheme] when [isDark] is true,
  /// and [lightScheme] otherwise.
  static ColorScheme getScheme(bool isDark) => isDark ? darkScheme : lightScheme;
}
