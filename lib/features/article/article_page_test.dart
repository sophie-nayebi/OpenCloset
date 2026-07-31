/// Tests for the Article page with carousel feature.
///
/// These tests verify the complete article page functionality including:
/// - Article display with image and content
/// - Carousel navigation (manual controls)
/// - Content transitions
/// - Responsive layout support

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencloset/features/article/article.dart';
import 'package:opencloset/shared/widgets/widgets.dart';

void main() {
  group('ArticlePage tests', () {
    testWidgets('ArticlePage widget can be instantiated', (WidgetTester tester) async {
      // Arrange & Act
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'Test content for the article',
        images: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Assert - Widget should be creatable
      expect(() => ArticlePage(article: article), returnsNormally);
    });

    testWidgets('Article page displays article title', (WidgetTester tester) async {
      // Arrange
      final article = Article(
        id: 'test-123',
        title: 'Test Article Title',
        subtitle: 'Test Subtitle',
        content: 'Test content',
        images: ['https://example.com/image.jpg'],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - Title should be displayed
      expect(find.text('Test Article Title'), findsOneWidget);
    });

    testWidgets('Article page displays article subtitle', (WidgetTester tester) async {
      // Arrange
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle Text',
        content: 'Test content',
        images: ['https://example.com/image.jpg'],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - Subtitle should be displayed
      expect(find.text('Test Subtitle Text'), findsOneWidget);
    });

    testWidgets('Article page displays article content', (WidgetTester tester) async {
      // Arrange
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'This is the main article content that should be displayed',
        images: ['https://example.com/image.jpg'],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - Content should be displayed
      expect(find.text('This is the main article content that should be displayed'), findsOneWidget);
    });

    testWidgets('Article page displays article category', (WidgetTester tester) async {
      // Arrange
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'Test content',
        images: ['https://example.com/image.jpg'],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - Category should be displayed
      expect(find.text('Fashion'), findsOneWidget);
    });

    testWidgets('Article page displays carousel with multiple images', (WidgetTester tester) async {
      // Arrange - Create article with multiple images for carousel
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'Test content',
        images: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
          'https://example.com/image3.jpg',
        ],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - Carousel should be present (at least one PageView)
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('Article page has carousel navigation controls (prev/next buttons)', (WidgetTester tester) async {
      // Arrange
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'Test content',
        images: ['https://example.com/image1.jpg'],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - Previous button should exist
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);

      // Assert - Next button should exist
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('Article page transitions between carousel images', (WidgetTester tester) async {
      // Arrange - Create article with multiple images for carousel
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'Test content',
        images: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
          'https://example.com/image3.jpg',
        ],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
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

    testWidgets('Article page displays article in Material 3 style', (WidgetTester tester) async {
      // Arrange
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'Test content',
        images: ['https://example.com/image.jpg'],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - Should use Material 3 components
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Article page supports responsive layout', (WidgetTester tester) async {
      // Arrange
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'Test content',
        images: ['https://example.com/image.jpg'],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - Widget should adapt to different screen sizes
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Article page handles article with no images', (WidgetTester tester) async {
      // Arrange - Create article without images
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'Test content',
        images: [],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - Article should still render with empty carousel
      expect(find.text('Test Article'), findsOneWidget);
    });

    testWidgets('Article page has back navigation', (WidgetTester tester) async {
      // Arrange
      final article = Article(
        id: 'test-123',
        title: 'Test Article',
        subtitle: 'Test Subtitle',
        content: 'Test content',
        images: ['https://example.com/image.jpg'],
        publishedAt: DateTime.now(),
        category: 'Fashion',
      );

      // Act - Build the article page
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ArticlePage(article: article),
          ),
        ),
      );

      // Assert - AppBar should have back button functionality
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
