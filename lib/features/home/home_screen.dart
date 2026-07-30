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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencloset/app/bootstrap.dart';

/// The home screen widget.
///
/// This widget represents the main landing page of the OpenCloset application.
/// It serves as the default view when no other content is displayed.
///
/// ## Navigation
///
/// - Tap the app icon to navigate to Settings
/// - Tap the theme icon to toggle light/dark mode
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a new home screen.
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenCloset'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.light_mode),
            tooltip: 'Toggle theme',
            onPressed: () {
              ref.read(themeProvider).toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Semantics(
          label: 'Home screen - Main landing page of the application. Tap the app icon or settings icon to navigate.',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.closet, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Welcome to OpenCloset',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your personal closet organizer',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Settings - Navigate to settings page to configure app preferences, view about information, and export data.',
                    child: _buildNavigationButton(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Semantics(
                    label: 'Toggle Theme - Switch between light and dark mode for the app.',
                    child: _buildNavigationButton(
                      icon: Icons.light_mode,
                      label: 'Toggle Theme',
                      onTap: () {
                        ref.read(themeProvider).toggleTheme();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey[200],
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
