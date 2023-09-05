import 'package:flutter/material.dart';

import 'package:frontend/app_theme.dart';

/// Show a simple representation of the tag bubble, that is grey with no
/// interactiveness.
class TagBubblePlain extends StatelessWidget {
  const TagBubblePlain({super.key, required this.id, required this.title});

  final String title;
  final int id;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: GeeLogicColourScheme.borderGrey,
        ),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: GeeLogicColourScheme.iconGrey),
        ),
      ),
    );
  }
}
