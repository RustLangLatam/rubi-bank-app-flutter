import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'types.dart';
import 'promo_card.dart';

class PromotionalCarousel extends ConsumerStatefulWidget {
  final List<Promotion> promotions;

  const PromotionalCarousel({super.key, required this.promotions});

  @override
  ConsumerState<PromotionalCarousel> createState() => _PromotionalCarouselState();
}

class _PromotionalCarouselState extends ConsumerState<PromotionalCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex < widget.promotions.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        widget.promotions.length - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.promotions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDark ? Colors.white : Colors.black;

    return Stack(
      children: [
        SizedBox(
          height: 128,
          child: PageView.builder(
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
        ),
        Positioned(
          left: 4,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              icon: Icon(Icons.chevron_left, color: buttonColor),
              onPressed: _goToPrevious,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
        ),
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              icon: Icon(Icons.chevron_right, color: buttonColor),
              onPressed: _goToNext,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}