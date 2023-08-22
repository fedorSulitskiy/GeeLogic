import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/helpers/uri_parser/uri_parse.dart';
import 'package:frontend/widgets/_archive/login_details.dart';
import 'package:frontend/widgets/common/loading_star.dart';
import 'package:frontend/widgets/user/users_algorithm.dart';

final _firebase = FirebaseAuth.instance;

/// The [ContributionsOrBookmarks] widget is a stateful widget that displays either the
/// user's contributions or their bookmarked algorithms, depending on the value of the
/// [isContributions] variable.
class ContributionsOrBookmarks extends StatefulWidget {
  const ContributionsOrBookmarks({super.key});

  @override
  State<ContributionsOrBookmarks> createState() =>
      _ContributionsOrBookmarksState();
}

class _ContributionsOrBookmarksState extends State<ContributionsOrBookmarks> {
  bool isContributions = true;

  /// The function [_getBookmarkedAlgorithmData] sends a POST request to a server to retrieve bookmarked
  /// algorithms list for a specific user.
  ///
  /// Returns:
  ///   The function [_getBookmarkedAlgorithmData] returns a [Future] object that resolves to a
  /// [List<dynamic>] in the future.
  Future<List<dynamic>>? _getBookmarkedAlgorithmData() async {
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "user_id": _firebase.currentUser!.uid,
    });
    http.Response response = await http.post(
      nodeUri('find_bookmarked_algos'),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  /// The function [_getContributedAlgorithmsData] sends a POST request to a local server to retrieve a
  /// list of contributed algorithms data for the current user.
  ///
  /// Returns:
  ///   The function [_getContributedAlgorithmsData] returns a [Future] that resolves to a
  /// [List<dynamic>].
  Future<List<dynamic>> _getContributedAlgorithmsData() async {
    final nodeUrl = nodeUri('show_by_user');
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
    final nodeUrl = nodeUri('show_tags');
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
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    "Contributions",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 24.0,
                        color: isContributions ? googleBlue : Colors.black87),
                  ),
                  onPressed: () {
                    setState(() {
                      isContributions = true;
                    });
                  },
                ),
                TextButton(
                  child: Text(
                    "Bookmarks",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 24.0,
                        color: !isContributions ? googleBlue : Colors.black87),
                  ),
                  onPressed: () {
                    setState(() {
                      isContributions = false;
                    });
                  },
                ),
              ],
            ),
          ),
          isContributions
              ? Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _getContributedAlgorithmsData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final contributedAlgorithms = snapshot.data!;
                        // FutureBuilder requesting tags
                        return contributedAlgorithms.isEmpty
                            ? const Text('No contributions yet')
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...contributedAlgorithms
                                        .map((contribution) {
                                      return FutureBuilder(
                                        future: _getRelatedTags(
                                            algoId: contribution['algo_id']),
                                        builder: (context, snapshotTags) {
                                          if (snapshotTags.connectionState ==
                                                  ConnectionState.done &&
                                              contribution['photo'] != null) {
                                            // Widget of the Contributed Algorithm
                                            return UsersAlgorithm(
                                              title: contribution['title'],
                                              imageURL: contribution['photo'],
                                              tags: snapshotTags.data!,
                                              algoId: contribution['algo_id'],
                                            );
                                          } else if (snapshotTags.hasError) {
                                            return Text(
                                                'Error: ${snapshotTags.error}');
                                          } else if (!snapshotTags.hasData ||
                                              snapshotTags.data!.isEmpty) {
                                            return const Text('');
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
                      }
                      return const LoadingStar();
                    },
                  ),
                )
              : Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _getBookmarkedAlgorithmData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final contributedAlgorithms = snapshot.data!;
                        // FutureBuilder requesting tags
                        return contributedAlgorithms.isEmpty
                            ? const Text('No bookmarks yet')
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...contributedAlgorithms
                                        .map((bookmarkedAlgo) {
                                      return FutureBuilder(
                                        future: _getRelatedTags(
                                            algoId: bookmarkedAlgo['algo_id']),
                                        builder: (context, snapshotTags) {
                                          if (snapshotTags.connectionState ==
                                                  ConnectionState.done &&
                                              bookmarkedAlgo['photo'] != null) {
                                            // Widget of the Contributed Algorithm
                                            return UsersAlgorithm(
                                              title: bookmarkedAlgo['title'],
                                              imageURL: bookmarkedAlgo['photo'],
                                              tags: snapshotTags.data!,
                                              algoId: bookmarkedAlgo['algo_id'],
                                            );
                                          } else if (snapshotTags.hasError) {
                                            return Text(
                                                'Error: ${snapshotTags.error}');
                                          } else if (!snapshotTags.hasData ||
                                              snapshotTags.data!.isEmpty) {
                                            return const Text('');
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
                      }
                      return const LoadingStar();
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
