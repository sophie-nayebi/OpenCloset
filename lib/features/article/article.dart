/// Article feature — article page with carousel.
///
/// This feature provides a complete article display page with:
/// - Article content (title, subtitle, body)
/// - Image carousel for gallery
/// - Manual navigation controls
/// - Responsive design support
/// - Material 3 styling
///
/// This file is the entry point for the article feature.
///
/// ## Usage
/// ```dart
/// import 'package:opencloset/features/article/article.dart';
///
/// const articlePage = ArticlePage(
///   article: Article(
///     id: '123',
///     title: 'Article Title',
///     subtitle: 'Article subtitle',
///     content: 'Article content',
///     images: ['url1.jpg', 'url2.jpg'],
///     publishedAt: DateTime.now(),
///     category: 'Fashion',
///   ),
/// );
/// ```

export 'article_page.dart';
