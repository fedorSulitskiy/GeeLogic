import 'package:flutter/material.dart';

import 'package:frontend/widgets/login/carousel_button.dart';
import 'package:frontend/widgets/login/scroll_indicator.dart';
import 'package:frontend/widgets/login/tutorial_card.dart';

import 'package:frontend/widgets/login/tutorial_cards/browse_card.dart';
import 'package:frontend/widgets/login/tutorial_cards/feedback_card.dart';
import 'package:frontend/widgets/login/tutorial_cards/submit_card.dart';
import 'package:frontend/widgets/login/tutorial_cards/welcome_card.dart';

/// List of tutorial cards to display.
List<TutorialCard> tutorialCards = [
  const TutorialCard(content: WelcomeCard()),
  const TutorialCard(content: BrowseCard()),
  const TutorialCard(content: SubmissionCard()),
  const TutorialCard(content: FeedbackCard()),
];

/// Displays the tutorial carousel consisting of [TutorialCard] widgets at the [LoginScreen].
class TutorialCarousel extends StatefulWidget {
  const TutorialCarousel({super.key});

  @override
  State<TutorialCarousel> createState() => _TutorialCarouselState();
}

class _TutorialCarouselState extends State<TutorialCarousel> {
  final PageController _pageController = PageController();
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Carousel
        PageView.builder(
          itemCount: tutorialCards.length,
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          itemBuilder: (context, index) {
            // Opacity animation
            final percentVisible = currentPageValue - index;
            final opacity = 1 - (percentVisible.abs() * 3).clamp(0.0, 1.0);
            return Opacity(
              opacity: opacity,
              child: tutorialCards[index],
            );
          },
        ),
        // Index indicator
        Positioned(
          bottom: 20.0,
          child: ScrollIndicator(
            cardsLength: tutorialCards.length,
            pageController: _pageController,
          ),
        ),
        if (currentPageValue < tutorialCards.length-1)
          Positioned(
            bottom: 340.0,
            right: 100.0,
            child: CarouselButton(
              direction: 'right',
              nextSlide: () {
                return _pageController.animateToPage(
                  currentPageValue.round() + 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
            ),
          ),
        if (currentPageValue > 0)
          Positioned(
            bottom: 340.0,
            left: 100.0,
            child: CarouselButton(
              direction: 'left',
              nextSlide: () {
                return _pageController.animateToPage(
                  currentPageValue.round() - 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
            ),
          ),
      ],
    );
  }
}
