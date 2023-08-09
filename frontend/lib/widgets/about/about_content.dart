import 'package:flutter/material.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25.0),
        Text(
          'About',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const Placeholder(),
      ],
    );
  }
}
