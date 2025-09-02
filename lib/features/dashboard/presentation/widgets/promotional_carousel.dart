import 'dart:async';

import 'package:flutter/material.dart';
import 'types.dart';
import 'promo_card.dart';

class PromotionalCarousel extends StatefulWidget {
  final List<Promotion> promotions;

  const PromotionalCarousel({super.key, required this.promotions});

  @override
  State<PromotionalCarousel> createState() => _PromotionalCarouselState();
}

class _PromotionalCarouselState extends State<PromotionalCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (widget.promotions.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_pageController.hasClients) return;

      final nextIndex = (_currentIndex + 1) % widget.promotions.length;

      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _goToPage(int newIndex) {
    if (!mounted || !_pageController.hasClients) return;

    _pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDark ? Colors.white : Colors.black;

    if (widget.promotions.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 122,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.promotions.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: PromoCard(promotion: widget.promotions[index]),
              );
            },
          ),
          if (widget.promotions.length > 1)
            Positioned(
              left: 4,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.chevron_left, color: buttonColor),
                  onPressed: () => _goToPage(
                      _currentIndex > 0
                          ? _currentIndex - 1
                          : widget.promotions.length - 1
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          if (widget.promotions.length > 1)
            Positioned(
              right: 4,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.chevron_right, color: buttonColor),
                  onPressed: () => _goToPage(
                      (_currentIndex + 1) % widget.promotions.length
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}