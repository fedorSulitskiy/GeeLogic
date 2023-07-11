import 'package:flutter/material.dart';

class PlaceholderCard extends StatelessWidget {
  const PlaceholderCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 500,
            child: Center(child: Text(title)),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}