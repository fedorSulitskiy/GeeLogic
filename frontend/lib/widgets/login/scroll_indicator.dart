import 'package:flutter/material.dart';
import 'package:frontend/widgets/_archive/login_details.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ScrollIndicator extends StatefulWidget {
  const ScrollIndicator({
    super.key,
    required this.cardsLength,
    required this.pageController,
  });

  final int cardsLength;
  final PageController pageController;

  @override
  State<ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<ScrollIndicator> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 240),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: SmoothPageIndicator(
            controller: widget.pageController,
            count: widget.cardsLength,
            effect: const WormEffect(
              radius: 20.0,
              spacing: 8.0,
              dotWidth: 10.0,
              dotHeight: 10.0,
              paintStyle: PaintingStyle.stroke,
              strokeWidth: 1.5,
              dotColor: Colors.grey,
              activeDotColor: googleBlue,
            ),
          ),
        ),
      ),
    );
  }
}
