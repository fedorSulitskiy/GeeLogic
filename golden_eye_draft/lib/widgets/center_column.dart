import 'package:flutter/material.dart';
import 'package:golden_eye_draft/widgets/gee_map_widget.dart';

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
          const MapWidget(),
          const PlaceholderCard(title: 'JS / Python Code'),
          const PlaceholderCard(title: 'Description'),
          const PlaceholderCard(title: 'Tags or sth'),
        ],
      ),
    );
  }
}

class PlaceholderCard extends StatelessWidget {
  const PlaceholderCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 110,
        width: 500,
        child: Center(child: Text(title)),
      ),
    );
  }
}
