import 'package:flutter/material.dart';

import 'package:frontend/widgets/common/loading_star.dart';

/// List of tutorial cards to display.
List<TutorialCard> tutorialCards = [
  TutorialCard(content: _WelcomeContent()),
  TutorialCard(content: Placeholder()),
  TutorialCard(content: Placeholder()),
  TutorialCard(content: Placeholder()),
];

/// Card to display the content of the tutorial.
class TutorialCard extends StatelessWidget {
  const TutorialCard({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 450.0,
        height: 600.0,
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 240),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// First tutorial card to display.
class _WelcomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const LoadingStar(),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          'We enable researchers and developers to easily host, access, and collaborate on earth observation algorithms.',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 19.0),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const _BulletPoint(
            text:
                "Host your analysis algorithms in a scalable cloud environment"),
        const _BulletPoint(
            text: "Interact with algorithms through an intuitive interface"),
        const _BulletPoint(
            text: "Engage in discussions with a community of experts"),
        const _BulletPoint(
            text: "Rapidly prototype new ideas and get feedback"),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          'By providing a centralized platform for earth observation algorithms, we aim to accelerate research, encourage collaboration, and drive the development of impactful solutions!',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 19.0),
        ),
      ],
    );
  }
}

/// Local bullet point widget, used in the [_WelcomeContent].
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5.0),
        Row(
          children: [
            const SizedBox(width: 15.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("•  "),
                SizedBox(
                  width: 310.0,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
