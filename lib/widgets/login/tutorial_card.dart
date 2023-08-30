import 'package:flutter/material.dart';

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

/// Local bullet point widget, used in the [WelcomeCard].
class BulletPoint extends StatelessWidget {
  const BulletPoint({required this.text, this.width = 310, super.key});

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("•  "),
            SizedBox(
              width: width,
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
    );
  }
}
