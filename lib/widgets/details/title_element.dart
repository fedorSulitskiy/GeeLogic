import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/providers/algo_info_provider.dart';
import 'package:frontend/models/algo_data.dart';
import 'package:frontend/screens/details_screen.dart';
import 'package:frontend/helpers/uri_parser/uri_parse.dart';
import 'package:frontend/custom_page_route.dart';

final _firebase = FirebaseAuth.instance;

/// The title element of the [DetailsCard] which contains the title of the algorithm
/// and two buttons: one to bookmark the algorithm and one to view the algorithm in
/// fullscreen, on [DetailsScreen].
class TitleElement extends ConsumerWidget {
  const TitleElement({super.key, required this.title, required this.data});

  final String title;
  final AlgoData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use [dataManager] [ChangeNotifierProvider] to instantly update the status of
    // the isBookmarked attribute of any algorithm, without having to wait for the
    // [FutureBuilder] to rebuild the widget.
    final dataManager = ref.watch(dataManagerProvider);
    
    /// Reponsive desing element to extract current screensize
    var screenSize = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 550.0 * screenSize.width / 1536,
          padding: const EdgeInsets.only(top: 20.0, left: 50.0),
          child: Text(
            title,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 40.0),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () async {
                  // Update data in the database

                  // Notice my use of provider for the bookmark status,
                  // and only for bookmark status. This allows for quick
                  // updates of the bookmark status without having to
                  // wait for the FutureBuilder to rebuild the widget.
                  if (dataManager.getDataItem(data.id).isBookmarked) {
                    // Delete bookmark if it exists
                    final headers = {'Content-Type': 'application/json'};
                    final body = json.encode({
                      "algo_id": data.id,
                      "user_id": _firebase.currentUser!.uid,
                    });
                    await http.delete(
                      nodeUri('remove_bookmark'),
                      headers: headers,
                      body: body,
                    );
                  } else {
                    // Add bookmark if it doesn't exist
                    final headers = {'Content-Type': 'application/json'};
                    final body = json.encode({
                      "algo_id": data.id,
                      "user_id": _firebase.currentUser!.uid,
                    });
                    await http.post(
                      nodeUri('bookmark_algo'),
                      headers: headers,
                      body: body,
                    );
                  }

                  // Update data locally
                  final updatedAlgo = AlgoData(
                    id: data.id,
                    title: data.title,
                    upVotes: data.upVotes,
                    downVotes: data.downVotes,
                    datePosted: data.datePosted,
                    image: data.image,
                    description: data.description,
                    isBookmarked:
                        !dataManager.getDataItem(data.id).isBookmarked,
                    api: data.api,
                    code: data.code,
                    userCreator: data.userCreator,
                    creatorName: data.creatorName,
                    creatorSurname: data.creatorSurname,
                    creatorImageURL: data.creatorImageURL,
                    tags: data.tags,
                    userVote: data.userVote,
                  );
                  // Notifies the [dataManagerProvider] that this algorithm has been bookmarked,
                  // by passing its index to the provider's notifier. This index will be used in
                  // CatalogueScreen to show bookmarked icon on the card, and in the
                  // DetailsCard on the same screen to show the details of the bookmarked algorithm.
                  dataManager.updateSingleData(
                    id: data.id,
                    newData: updatedAlgo,
                  );
                },
                icon: Icon(
                  dataManager.getDataItem(data.id).isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CustomPageRoute(
                        builder: (ctx) => DetailsScreen(data: data),
                      ),
                    );
                  },
                  icon: const Icon(Icons.fullscreen, size: 30.0)),
            ],
          ),
        )
      ],
    );
  }
}
