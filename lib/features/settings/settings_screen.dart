/// Settings screen widget.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencloset/app/bootstrap.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Consumer(
        builder: (context, ref, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: [
              _buildThemeToggle(context, ref),
              _buildAboutSection(context),
              _buildExportOption(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Text('Theme:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => ref.read(themeProvider).toggleTheme(),
            child: Container(
              key: const Key('theme-toggle'),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ref.watch(themeProvider).themeMode == ThemeMode.dark
                      ? const Icon(Icons.dark_mode, size: 20.0)
                      : const Icon(Icons.light_mode, size: 20.0),
                  const SizedBox(width: 4),
                  Text(
                    ref.watch(themeProvider).themeMode == ThemeMode.dark ? 'Dark' : 'Light',
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              if (ref.watch(themeProvider).themeMode == ThemeMode.dark) {
                ref.read(themeProvider).setThemeMode(ThemeMode.light);
              } else {
                ref.read(themeProvider).setThemeMode(ThemeMode.dark);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text('Toggle'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Semantics(
        label: 'About OpenCloset - Version 1.0.0, All your data belongs to you. Open source project on GitHub.',
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('About OpenCloset', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              const Text('Version 1.0.0', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
              const SizedBox(height: 4.0),
              const Text('All your data belongs to you', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
              const SizedBox(height: 12.0),
              InkWell(
                onTap: () {
                  // Open GitHub repository in browser
                  // TODO: Implement URL launcher for GitHub link
                },
                child: Row(
                  children: [
                    const Icon(Icons.code, color: Colors.blue, size: 18),
                    const SizedBox(width: 8),
                    const Text('View on GitHub', style: TextStyle(fontSize: 14.0, color: Colors.blue, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      key: const Key('export-option'),
      child: Material(
        color: Colors.grey[300],
        elevation: 2.0,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Export Feature'),
                  content: const Text('The export feature is currently disabled. This feature will be available in a future update.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.download, color: Colors.grey, size: 28.0),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Export Data', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4.0),
                      const Text('Coming soon', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.info_outline, color: Colors.grey, size: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
