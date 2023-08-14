import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/loading_star.dart';

class UserCreatorDisplay extends StatelessWidget {
  const UserCreatorDisplay({
    super.key,
    required this.user,
    required this.dateCreated,
  });

  final String user;
  final String dateCreated;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          // height: 20.0,
          child: FutureBuilder(
            future:
                FirebaseFirestore.instance.collection('users').doc(user).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final data = snapshot.data!.data();
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 18.0,
                      backgroundImage: NetworkImage(data!['imageURL']),
                    ),
                    const SizedBox(width: 5.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'by ${data['name']} ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              data['surname'],
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Text('created $dateCreated', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12.0)),
                      ],
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text("Something went wrong");
              } else if (!snapshot.hasData) {
                return const Text('No data available.');
              }
              return const LoadingStar();
            },
          ),
        ),
        _Divider(),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
      child: Divider(),
    );
  }
}
