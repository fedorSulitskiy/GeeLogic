import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/screens/login_screen.dart';

import 'package:frontend/widgets/user/contributions_or_bookmarks.dart';
import 'package:frontend/widgets/common/loading_star.dart';

/// Organises the content of the [UserScreen].
class UserContent extends StatefulWidget {
  const UserContent({super.key});

  @override
  State<UserContent> createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  final _firebase = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25.0),
        // FutureBuilder responsible for building the user specifict content including:
        // - name
        // - surname
        // - biography
        // - image avatar
        // TODO: clean up loading animations
        Stack(
          children: [
            Positioned(
              top: 0,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Sign out of Firebase instance
                  _firebase.signOut();
                  // Navigate to LoginScreen with no option to go back
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const LoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_firebase.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  /// [Map] of [String] with relecant content from Firebase Firestore
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(data['imageURL']),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'],
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(
                                data['surname'],
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          )
                        ],
                      ),
                      const Divider(),
                      Text(
                        data['bio'],
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 20.0),
                      ),
                      const SizedBox(height: 25.0),
                      const Divider(),
                    ],
                  );
                }
                return const Center(
                  child: LoadingStar(),
                );
              },
            ),
          ],
        ),
        // FutureBuilder responsible for showing algorithms contributed by the user
        // There are two layers here since two requests must be made:
        //  - request for title and imageURL(photo)
        //  - request for tags related to algorithm
        // TODO: clean up loading animations
        //  error handling and empty state handling
        const ContributionsOrBookmarks(),
      ],
    );
  }
}
