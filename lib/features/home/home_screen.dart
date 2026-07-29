/// Home screen widget.
///
/// This is the main landing page of the application.
///
/// Usage:
/// ```dart
/// import 'package:opencloset/features/home/home_screen.dart';
///
/// const homeScreen = HomeScreen();
/// ```

import 'package:flutter/material.dart';

/// The home screen widget.
///
/// This widget represents the main landing page of the OpenCloset application.
/// It serves as the default view when no other content is displayed.
class HomeScreen extends StatelessWidget {
  /// Creates a new home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
