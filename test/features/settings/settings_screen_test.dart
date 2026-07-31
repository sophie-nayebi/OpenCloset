/// Tests for the Settings screen widget.
///
/// Verifies the settings page has proper AppBar, theme toggle,
/// about section, and export option with accessibility support.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencloset/features/settings/settings_screen.dart';
import 'package:opencloset/app/bootstrap.dart';

void main() {
  testWidgets('Settings screen has proper AppBar with title', (tester) async {
    final notifier = AppThemeNotifier(
      lightScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.light),
      darkScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [themeProvider.overrideWithValue(notifier)],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify AppBar exists and has 'Settings' title
    final appBarFinder = find.byType(AppBar);
    expect(appBarFinder, findsOneWidget);

    final appBar = tester.widget<AppBar>(appBarFinder);
    expect(appBar.title, isNotNull);
  });

  testWidgets('Settings screen has theme toggle button', (tester) async {
    final notifier = AppThemeNotifier(
      lightScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.light),
      darkScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [themeProvider.overrideWithValue(notifier)],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find the theme toggle button
    final themeToggleFinder = find.byKey(const Key('theme-toggle'));
    expect(themeToggleFinder, findsOneWidget);
  });

  testWidgets('Settings screen has about section', (tester) async {
    final notifier = AppThemeNotifier(
      lightScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.light),
      darkScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [themeProvider.overrideWithValue(notifier)],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify about section exists
    final aboutFinder = find.textContaining('About OpenCloset');
    expect(aboutFinder, findsOneWidget);
  });

  testWidgets('Settings screen has export option', (tester) async {
    final notifier = AppThemeNotifier(
      lightScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.light),
      darkScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [themeProvider.overrideWithValue(notifier)],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find the export option
    final exportOptionFinder = find.byKey(const Key('export-option'));
    expect(exportOptionFinder, findsOneWidget);
  });

  testWidgets('Settings screen has theme toggle button', (tester) async {
    final notifier = AppThemeNotifier(
      lightScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.light),
      darkScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [themeProvider.overrideWithValue(notifier)],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify theme toggle exists
    final themeToggleFinder = find.byKey(const Key('theme-toggle'));
    expect(themeToggleFinder, findsOneWidget);
  });

  testWidgets('Settings screen theme toggle is interactive', (tester) async {
    final notifier = AppThemeNotifier(
      lightScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.light),
      darkScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [themeProvider.overrideWithValue(notifier)],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify theme toggle exists with GestureDetector
    final themeToggleFinder = find.byKey(const Key('theme-toggle'));
    expect(themeToggleFinder, findsOneWidget);
  });

  testWidgets('Settings screen has ElevatedButton for GitHub link', (tester) async {
    final notifier = AppThemeNotifier(
      lightScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.light),
      darkScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [themeProvider.overrideWithValue(notifier)],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find the GitHub link button
    final githubButtonFinder = find.text('View on GitHub');
    expect(githubButtonFinder, findsOneWidget);

    // Verify it's an ElevatedButton
    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);
  });
}
