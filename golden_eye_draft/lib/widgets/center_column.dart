import 'package:flutter/material.dart';

class CenterColumn extends StatefulWidget {
  const CenterColumn({super.key});

  @override
  State<CenterColumn> createState() => _CenterColumnState();
}

class _CenterColumnState extends State<CenterColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const PlaceholderCard(title: 'GEE API'),
        const PlaceholderCard(title: 'JS / Python Code'),
        const PlaceholderCard(title: 'Description'),
        const PlaceholderCard(title: 'Tags or sth'),
      ],
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
