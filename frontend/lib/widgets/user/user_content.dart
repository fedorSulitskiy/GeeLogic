import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/widgets/user/contributed_algorithm.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/widgets/common/loading_star.dart';

const borderColor = Color.fromARGB(255, 203, 205, 214);

class UserContent extends StatefulWidget {
  const UserContent({super.key});

  @override
  State<UserContent> createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  final _firebase = FirebaseAuth.instance;

  /// The function [_getContributedAlgorithmsData] sends a POST request to a local server to retrieve a
  /// list of contributed algorithms data for the current user.
  ///
  /// Returns:
  ///   The function [_getContributedAlgorithmsData] returns a [Future] that resolves to a
  /// [List<dynamic>].
  Future<List<dynamic>> _getContributedAlgorithmsData() async {
    final nodeUrl = Uri.parse('http://localhost:3000/node_api/show_by_user');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "user_creator": _firebase.currentUser!.uid,
    });
    http.Response response =
        await http.post(nodeUrl, headers: headers, body: body);
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  /// The function [_getRelatedTags] sends a POST request to a specified URL with a JSON body containing
  /// an algorithm ID, and returns a list of dynamic objects parsed from the response body.
  ///
  /// Args:
  ///   [algoId] (int): The [algoId] parameter is an integer that represents the ID of an algorithm.
  ///
  /// Returns:
  ///   The function [_getRelatedTags] returns a [Future] that resolves to a [List<dynamic>].
  Future<List<dynamic>> _getRelatedTags({required int algoId}) async {
    final nodeUrl = Uri.parse('http://localhost:3000/node_api/show_tags');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "algo_id": algoId,
    });
    http.Response response =
        await http.post(nodeUrl, headers: headers, body: body);
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

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
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Text(
                            data['surname'],
                            style: Theme.of(context).textTheme.displayMedium,
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
        // FutureBuilder responsible for showing algorithms contributed by the user
        // There are two layers here since two requests must be made:
        //  - request for title and imageURL(photo)
        //  - request for tags related to algorithm
        // TODO: clean up loading animations
        FutureBuilder<List<dynamic>>(
          future: _getContributedAlgorithmsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final contributedAlgorithms = snapshot.data!;
              // FutureBuilder requesting tags
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (contributedAlgorithms.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 4.0),
                        child: Text(
                          "User's Algorithms",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 24.0, color: Colors.black87),
                        ),
                      ),
                    ...contributedAlgorithms.map((contribution) {
                      return FutureBuilder(
                        future:
                            _getRelatedTags(algoId: contribution['algo_id']),
                        builder: (context, snapshotTags) {
                          if (snapshotTags.connectionState ==
                                  ConnectionState.done &&
                              contribution['imageURL'] != null) {
                            // Widget of the Contributed Algorithm
                            return ContributedAlgorithm(
                              title: contribution['title'],
                              imageURL: contribution['photo'],
                              tags: snapshotTags.data!,
                            );
                          } else if (snapshotTags.hasError) {
                            return Text('Error: ${snapshotTags.error}');
                          } else if (!snapshotTags.hasData ||
                              snapshotTags.data!.isEmpty) {
                            return const Text('No data available.');
                          }
                          return const LoadingStar();
                        },
                      );
                    }).toList(),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data available.');
            }
            return const LoadingStar();
          },
        ),
      ],
    );
  }
}
