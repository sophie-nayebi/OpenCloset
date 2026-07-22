/// Static/immutable providers for configuration values.
///
/// Uses [Provider.value<T>()] for providers that hold immutable configuration
/// values. These are ideal for app-wide settings that don't change at runtime,
/// such as app version, feature flags, or default configuration.
///
/// ## When to use
///
/// - App version numbers
/// - Feature flags
/// - Default configuration values
/// - App name and branding
///
/// ## Example
///
/// ```dart
/// final appVersionProvider = Provider.value<String>(
///   '1.0.0',
///   name: 'App Version',
/// );
/// ```

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Static app version provider.
///
/// This is an immutable provider that holds the current application version.
/// The value is set at initialization and never changes at runtime.
///
/// Example:
/// ```dart
/// final version = appVersionProvider.read();
/// // Returns '0.1.0'
/// ```
final appVersionProvider = Provider.value<String>(
  '0.1.0',
  name: 'App Version',
);

/// Static app name provider.
///
/// This is an immutable provider that holds the application's name.
///
/// Example:
/// ```dart
/// final appName = appNameProvider.read();
/// // Returns 'OpenCloset'
/// ```
final appNameProvider = Provider.value<String>(
  'OpenCloset',
  name: 'App Name',
);

/// Static feature flag provider.
///
/// Demonstrates how to use static providers for feature flags.
/// 
/// Example:
/// ```dart
/// final enableAIProvider = Provider.value<bool>(false, name: 'Enable AI');
/// ```
/// TODO: replace with real feature flag
final enableAIProvider = Provider.value<bool>(false, name: 'Enable AI');
