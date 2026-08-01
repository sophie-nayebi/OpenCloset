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

import 'package:opencloset/shared/constants/theme_config.dart';

/// Application color scheme.
///
/// This class provides the default color schemes for the application.
/// The actual color scheme instances are defined in [ThemeConfig] to avoid
/// duplication and ensure consistent color usage.
class AppColorScheme {
  /// Light color scheme.
  static final light = ThemeConfig.lightScheme;

  /// Dark color scheme.
  static final dark = ThemeConfig.darkScheme;
}
