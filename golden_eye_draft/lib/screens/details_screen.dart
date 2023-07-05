import 'package:flutter/material.dart';
import 'package:golden_eye_draft/widgets/center_column.dart';
import 'package:golden_eye_draft/widgets/side_column.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GIS Catalogue',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SideColumn(),
          CenterColumn(),
          SideColumn(),
        ],
      ),
    );
  }
}
