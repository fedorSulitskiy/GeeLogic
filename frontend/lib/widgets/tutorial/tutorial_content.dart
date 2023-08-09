import 'package:flutter/material.dart';

class TutorialContent extends StatelessWidget {
  const TutorialContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25.0),
        Text(
          'Tutorial',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const Placeholder(),
      ],
    );
  }
}
