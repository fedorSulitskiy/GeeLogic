import 'package:flutter/material.dart';

import 'package:frontend/app_theme.dart';

/// Widget that displays cancel button at the bottom of the [EditScreen].
class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Simply go back to the previous screen.
        Navigator.pop(context);
      },
      // style: TextButton.styleFrom(maximumSize: const Size(100, 30)),
      child: SizedBox(
        height: 30,
        child: Text(
          'cancel',
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: GeeLogicColourScheme.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
