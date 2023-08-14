import 'package:flutter/material.dart';
import 'package:frontend/models/algo_data.dart';

import 'package:frontend/screens/details_screen.dart';

// Custom page route without distracting phone-like animation
class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}

class TitleElement extends StatelessWidget {
  const TitleElement({super.key, required this.title, required this.data});

  final String title;
  final AlgoData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 50.0),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 40.0),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CustomPageRoute(
                        builder: (ctx) => DetailsScreen(data: data),
                      ),
                    );
                  },
                  icon: const Icon(Icons.fullscreen, size: 30.0)),
            ],
          ),
        )
      ],
    );
  }
}
