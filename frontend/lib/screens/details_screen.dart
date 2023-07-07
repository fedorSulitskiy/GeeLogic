import 'package:flutter/material.dart';

import 'package:frontend/widgets/center_column.dart';

// Screen for details of each algorithm
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
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
        body: const Center(child: CenterColumn()),
      ),
    );
  }
}
