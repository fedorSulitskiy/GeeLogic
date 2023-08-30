import 'package:flutter/material.dart';
import 'package:frontend/widgets/login/tutorial_card.dart';

/// Second tutorial card to display.
class BrowseCard extends StatelessWidget {
  const BrowseCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Browse our Resources!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Text(
          'Browse our catalogue of algorithms submitted by researches and developers.',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 19.0),
        ),
        const SizedBox(
          height: 15.0
        ),
        Image.asset(
          "assets/browse_gif.gif",
        ),
        const SizedBox(
          height: 15.0
        ),
        const BulletPoint(text: 'Look into algorithms written in JavaScript and Python APIs'),
        const BulletPoint(text: 'View the rendering of each algorithm in Google Earth Engine instantly'),
        // const BulletPoint(text: "Comment and discuss other people's research"),
      ],
    );
  }
}

class _MiniCatalogueScreen extends StatelessWidget {
  const _MiniCatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
