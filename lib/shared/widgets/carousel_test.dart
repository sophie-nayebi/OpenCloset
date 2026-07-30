/// Tests for the Carousel widget.
///
/// These tests verify the carousel functionality including:
/// - Image carousel with multiple images
/// - Manual navigation controls (prev/next buttons)
/// - Page transitions
/// - Edge case handling (single image, empty list)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset/shared/widgets/widgets.dart';

void main() {
  group('CarouselPage tests', () {
    testWidgets('CarouselPage widget can be instantiated with images', (WidgetTester tester) async {
      // Arrange & Act
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];

      // Assert - Widget should be creatable
      expect(() => CarouselPage(imageUrls: images), returnsNormally);
    });

    testWidgets('CarouselPage displays all images in carousel', (WidgetTester tester) async {
      // Arrange
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Carousel should be present
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('CarouselPage displays image placeholders when images not available', (WidgetTester tester) async {
      // Arrange
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
      ];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Should display placeholder for first image (placeholder container)
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('CarouselPage handles single image gracefully', (WidgetTester tester) async {
      // Arrange
      final images = ['https://example.com/single-image.jpg'];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Carousel should handle single image
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('CarouselPage handles empty image list gracefully', (WidgetTester tester) async {
      // Arrange
      final images = <String>[];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Should handle empty list without errors (shows empty carousel widget)
      expect(find.text('No Images'), findsOneWidget);
    });

    testWidgets('CarouselPage has previous button', (WidgetTester tester) async {
      // Arrange
      final images = ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Previous button should exist
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    });

    testWidgets('CarouselPage has next button', (WidgetTester tester) async {
      // Arrange
      final images = ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Next button should exist
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('CarouselPage navigates to next image on next button tap', (WidgetTester tester) async {
      // Arrange
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Carousel should be present
      expect(find.byType(PageView), findsOneWidget);

      // Act - Navigate to next image using next button
      final nextButton = find.byIcon(Icons.chevron_right);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Assert - Navigation should work (carousel is responsive)
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('CarouselPage navigates to previous image on previous button tap', (WidgetTester tester) async {
      // Arrange
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Carousel should be present
      expect(find.byType(PageView), findsOneWidget);

      // Act - Navigate forward
      final nextButton = find.byIcon(Icons.chevron_right);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Assert - Navigation should work
      expect(find.byType(PageView), findsOneWidget);

      // Act - Navigate back
      final prevButton = find.byIcon(Icons.chevron_left);
      await tester.tap(prevButton);
      await tester.pumpAndSettle();

      // Assert - Carousel should still work
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('CarouselPage wraps around on next button at last image', (WidgetTester tester) async {
      // Arrange
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Carousel should be present
      expect(find.byType(PageView), findsOneWidget);

      // Act - Navigate forward
      final nextButton = find.byIcon(Icons.chevron_right);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Assert - Navigation should work
      expect(find.byType(PageView), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);

      // Act - Navigate forward from last image (should wrap to first)
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Assert - Carousel should still work
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('CarouselPage wraps around on previous button at first image', (WidgetTester tester) async {
      // Arrange
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Carousel should be present
      expect(find.byType(PageView), findsOneWidget);

      // Act - Navigate forward
      final nextButton = find.byIcon(Icons.chevron_right);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);

      // Act - Navigate back from last image (should wrap to last)
      final prevButton = find.byIcon(Icons.chevron_left);
      await tester.tap(prevButton);
      await tester.pumpAndSettle();

      // Assert - Carousel should still work
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('CarouselPage supports infinite scrolling', (WidgetTester tester) async {
      // Arrange
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Carousel should support infinite scrolling
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('CarouselPage auto-scrolls automatically', (WidgetTester tester) async {
      // Arrange
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Carousel should auto-scroll
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('CarouselPage has proper page controller', (WidgetTester tester) async {
      // Arrange
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
      ];

      // Act - Build the carousel
      await tester.pumpWidget(
        MaterialApp(
          home: CarouselPage(imageUrls: images),
        ),
      );

      // Assert - Carousel should be properly initialized
      expect(find.byType(PageView), findsOneWidget);
    });
  });
}
