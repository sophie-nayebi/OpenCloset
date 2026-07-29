/// Material 3 theme and color scheme configuration.
///
/// This file defines the application-wide Material Design 3 theming,
/// including color schemes, typography, and theme data.
///
/// Usage:
/// ```dart
/// import 'package:opencloset/app/theme.dart';
///
/// ThemeData theme = ThemeData(
///   colorScheme: AppColorScheme.light,
/// );
/// ```

import 'package:flutter/material.dart';

/// The light theme for the application.
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.light,
  ),
);

/// The dark theme for the application.
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  ),
);

/// System theme for automatic switching.
final systemTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
);

/// Application color scheme.
class AppColorScheme {
  /// Light color scheme.
  static final light = ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.light,
  );

  /// Dark color scheme.
  static final dark = ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  );
}
