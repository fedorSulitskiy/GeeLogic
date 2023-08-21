import 'package:flutter/material.dart';

/// A simple widget to display the user who created the algorithm and the date
/// it was created.
class UserCreatorDisplay extends StatelessWidget {
  const UserCreatorDisplay({
    super.key,
    required this.name,
    required this.surname,
    required this.imageURL,
    required this.dateCreated,
  });

  final String name;
  final String surname;
  final String imageURL;
  final String dateCreated;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          // height: 20.0,
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.0,
                backgroundImage: NetworkImage(imageURL),
              ),
              const SizedBox(width: 5.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'by $name ',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        surname,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Text(
                    'created $dateCreated',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: 12.0),
                  ),
                ],
              )
            ],
          ),
        ),
        _Divider(),
      ],
    );
  }
}

/// Custom divider widget.
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
      child: Divider(),
    );
  }
}
