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
import 'package:opencloset/app/routes.dart';
import 'package:opencloset/app/theme.dart';

/// The main application widget.
///
/// This widget is the root of the application and configures
/// the GoRouter for navigation and theming.
class MyApp extends StatelessWidget {
  /// Creates a new MyApp instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OpenCloset',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
      ],
      routerConfig: routes.router,
    );
  }
}
