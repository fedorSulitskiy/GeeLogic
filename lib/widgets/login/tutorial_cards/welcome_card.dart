import 'package:flutter/material.dart';

import 'package:frontend/widgets/common/loading_star.dart';
import 'package:frontend/widgets/login/tutorial_card.dart';

/// First tutorial card to display.
class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});
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
        const BulletPoint(
            text:
                "Host your analysis algorithms in a scalable cloud environment"),
        const BulletPoint(
            text: "Interact with algorithms through an intuitive interface"),
        const BulletPoint(
            text: "Engage in discussions with a community of experts"),
        const BulletPoint(
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
