/// Article page widget for displaying articles with carousel.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opencloset/shared/widgets/carousel.dart';

class Article {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final List<String> images;
  final DateTime publishedAt;
  final String category;

  const Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.images,
    required this.publishedAt,
    required this.category,
  });
}

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildContent(),
            _buildCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(article.title),
          if (article.subtitle.isNotEmpty) Text(article.subtitle),
          Text('Category: ${article.category}'),
          Text('Published: ${_formatDate(article.publishedAt)}'),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Text(article.content),
    );
  }

  Widget _buildCarousel() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16.0),
      child: CarouselPage(imageUrls: article.images),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
