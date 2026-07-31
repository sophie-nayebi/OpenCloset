/// Carousel widget for displaying image carousels.
import 'package:flutter/material.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({
    super.key,
    required this.imageUrls,
  });

  final List<String> imageUrls;

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (widget.imageUrls.isEmpty) return;
    final nextIndex = (_currentPage + 1) % widget.imageUrls.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _previousPage() {
    if (widget.imageUrls.isEmpty) return;
    final prevIndex = (_currentPage - 1 + widget.imageUrls.length) % widget.imageUrls.length;
    _pageController.animateToPage(
      prevIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const _EmptyCarousel();
    }

    return Column(
      children: [
        _buildNavigationControls(),
        Expanded(
          child: _buildCarousel(),
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        return _buildImage(index);
      },
    );
  }

  Widget _buildImage(int index) {
    return Image.network(
      widget.imageUrls[index],
    );
  }

  Widget _buildImagePlaceholder(int index) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
          ],
        ),
      ),
      child: Center(
        child: Semantics(
          label: 'Image placeholder $index',
          child: const Icon(Icons.image, size: 48, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      key: const Key('carousel-navigation-controls'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Semantics(
            label: 'Previous page',
            onTap: _previousPage,
            child: _buildNavigationButton(
              icon: Icons.chevron_left,
              onPressed: _previousPage,
            ),
          ),
          if (widget.imageUrls.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Semantics(
                label: 'Page $_currentPage of ${widget.imageUrls.length}',
                child: Text(
                  '$_currentPage/${widget.imageUrls.length}',
                ),
              ),
            ),
          Semantics(
            label: 'Next page',
            onTap: _nextPage,
            child: _buildNavigationButton(
              icon: Icons.chevron_right,
              onPressed: _nextPage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.9),
      elevation: 2,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Semantics(
            label: icon == Icons.chevron_left
                ? 'Previous'
                : 'Next',
            child: Icon(icon, color: const Color(0xFF212121), size: 28),
          ),
        ),
      ),
    );
  }
}

class _EmptyCarousel extends StatelessWidget {
  const _EmptyCarousel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No Images', style: TextStyle(fontSize: 20, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
