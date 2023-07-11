import 'package:flutter/material.dart';

import 'package:frontend/widgets/code_widget.dart';
// import 'package:frontend/widgets/gee_map_widget.dart';

// Placeholders
import 'package:frontend/widgets/placeholders/data/placeholder_data.dart';
import 'package:frontend/widgets/placeholders/placeholder_card.dart';
import 'package:frontend/widgets/placeholders/placeholder_map.dart';

// The structure of the details page is developed here
class CenterColumn extends StatefulWidget {
  const CenterColumn({super.key});

  @override
  State<CenterColumn> createState() => _CenterColumnState();
}

class _CenterColumnState extends State<CenterColumn> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Title',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          // const MapWidget(),
          const PlaceholderMap(), // Useful to prevent use of extra resources when frequently reloading
          const Card(
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: 500,
              child: CodeDisplayWidget(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const PlaceholderCard(title: description),
          const PlaceholderCard(title: 'Tags or sth'),
        ],
      ),
    );
  }
}
