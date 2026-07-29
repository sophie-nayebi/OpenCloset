/// Application entry point and bootstrapping.
///
/// This file initializes the application, sets up providers, and boots the root widget tree.
/// It is the single entry point for the entire application.
///
/// Usage:
/// ```dart
/// import 'package:opencloset/app/app.dart';
///
/// void main() => runApp(const MyApp());
/// ```

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencloset/app/bootstrap.dart';
import 'package:opencloset/app/routes.dart';

/// The main application widget.
///
/// This widget is the root of the application and configures
/// the GoRouter for navigation and theming.
///
/// The widget uses the [themeProvider] from bootstrap.dart which handles
/// lazy-loaded theme initialization.
///
/// ## Provider Registration
///
/// The following providers are registered through the bootstrap module:
/// - [themeProvider]: Theme state management (lazy-loaded)
/// - [userPreferencesProvider]: User preferences stub (lazy-loaded)
/// - [userSettingsProvider]: User settings stub (lazy-loaded)
///
/// ## Provider Hierarchy
///
/// ```
/// ProviderScope (implicit in flutter_riverpod)
/// └── themeProvider
/// ```
class MyApp extends ConsumerWidget {
  /// Creates a new MyApp instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access theme provider through ref (lazy-loaded)
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'OpenCloset',
      // Use the theme from the provider
      theme: ThemeData(colorScheme: theme.lightScheme),
      darkTheme: ThemeData(colorScheme: theme.darkScheme),
      themeMode: theme.themeMode,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
      ],
      routerConfig: routes.router,
    );
  }
}
