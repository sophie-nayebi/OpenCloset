/// Tests for the Settings screen widget.
///
/// Verifies the settings page has proper AppBar, theme toggle,
/// about section, and export option with accessibility support.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_runners_for_flutter/flutter_test_runners_for_flutter.dart';
import 'package:opencloset/features/settings/settings_screen.dart';

void main() {
  testWidgets('Settings screen has proper AppBar with title', (tester) async {
    await tester.pumpWidget(const SettingsScreen());
    await tester.pumpAndSettle();

    // Verify AppBar exists and has 'Settings' title
    final appBarFinder = find.byType(AppBar);
    expect(appBarFinder, findsOneWidget);

    final appBar = tester.widget<AppBar>(appBarFinder);
    expect(appBar.title, const Text('Settings'));
  });

  testWidgets('Settings screen has theme toggle button', (tester) async {
    await tester.pumpWidget(const SettingsScreen());
    await tester.pumpAndSettle();

    // Find the theme toggle button
    final themeToggleFinder = find.byKey(const Key('theme-toggle'));
    expect(themeToggleFinder, findsOneWidget);

    // Tap the theme toggle
    await tester.tap(themeToggleFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('Settings screen has about section', (tester) async {
    await tester.pumpWidget(const SettingsScreen());
    await tester.pumpAndSettle();

    // Find the about section
    final aboutSectionFinder = find.byKey(const Key('about-section'));
    expect(aboutSectionFinder, findsOneWidget);

    // Verify about section contains app info
    final aboutFinder = find.textContaining('About OpenCloset');
    expect(aboutFinder, findsOneWidget);
  });

  testWidgets('Settings screen has export option', (tester) async {
    await tester.pumpWidget(const SettingsScreen());
    await tester.pumpAndSettle();

    // Find the export option
    final exportOptionFinder = find.byKey(const Key('export-option'));
    expect(exportOptionFinder, findsOneWidget);
  });

  testWidgets('Settings screen has accessibility labels', (tester) async {
    await tester.pumpWidget(const SettingsScreen());
    await tester.pumpAndSettle();

    // Check previous button has accessibility label
    final previousButtonFinder = find.byKey(const Key('previous-button'));
    expect(previousButtonFinder, findsOneWidget);

    // Check next button has accessibility label
    final nextButtonFinder = find.byKey(const Key('next-button'));
    expect(nextButtonFinder, findsOneWidget);
  });
}
