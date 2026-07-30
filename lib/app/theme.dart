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

/// Application color scheme.
///
/// This class provides the default color schemes for the application.
/// The actual color scheme instances are defined in bootstrap.dart to avoid
/// duplication and ensure consistent color usage.
class AppColorScheme {
  /// Light color scheme.
  static final light = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6750A4),
    brightness: Brightness.light,
  );

  /// Dark color scheme.
  static final dark = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6750A4),
    brightness: Brightness.dark,
  );
}
