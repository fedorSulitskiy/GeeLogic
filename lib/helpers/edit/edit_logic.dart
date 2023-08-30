import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/uri_parser/uri_parse.dart';
import 'package:frontend/models/algo_data.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/providers/algo_info_provider.dart';
import 'package:frontend/widgets/input/input_content.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// This function is called when the user presses the [SubmitButton] widget in the
/// [EditScreen]. It assists with the process of updating the algorithm in the
/// database.
///
/// Logic of the process:
///
///   - IF CODE IS MODIFIED:
///     - GET NEW THUMBNAIL IMAGE
///     - DELETE OLD THUMBNAIL IMAGE
///     - UPLOAD IT TO FIREBASE
///   - DELETE ALL TAGS
///   - LOOP ADD NEW TAGS
///   - PATCH GENERAL DATA
///
Future<bool> editLogic({
  required ScaffoldMessengerState scaffoldMessengerContext,
  required BuildContext context,
  required String title,
  required String description,
  required List<Tag> tags,
  required String code,
  required String mapCode,
  required bool isPython,
  required AlgoData initialAlgoData,
  required WidgetRef ref,
}) async {
  String imageURL = initialAlgoData.image;

  /// Error message snack bar
  SnackBar snackBar({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return SnackBar(
      backgroundColor: color,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 45.0,
          ),
          const SizedBox(width: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Delete mechanism to undo previous transactions.
  // Future undoTransactionChanges() async {}

  // See if the code has been modified. If so, delete the old thumbnail
  // and upload the new one.
  if (initialAlgoData.code != code) {
    final String imageBytes;

    // Delete the current thumbnail image
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final desertRef =
          storageRef.child("algo_images/${initialAlgoData.id}.jpg");

      await desertRef.delete();
    } catch (e) {
      scaffoldMessengerContext.clearSnackBars();
      scaffoldMessengerContext.showSnackBar(
        snackBar(
          color: googleRed,
          icon: Icons.error_outline_outlined,
          subtitle: e.toString(),
          title: "Something went wrong!",
        ),
      );
      return false;
    }

    // Get thumbnail image
    try {
      final thumbnailUrl = thumbnailUri('get_thumbnail');
      Map<String, String> body = {
        'data': mapCode,
      };
      final thumbnailResponse = await http.post(thumbnailUrl, body: body);
      imageBytes = thumbnailResponse.body;
      if (thumbnailResponse.statusCode != 200) {
        throw Exception('There was an error processing the image.');
      }
    } catch (e) {
      scaffoldMessengerContext.clearSnackBars();
      scaffoldMessengerContext.showSnackBar(
        snackBar(
          color: googleRed,
          icon: Icons.error_outline_outlined,
          subtitle: e.toString(),
          title: "Something went wrong!",
        ),
      );
      return false;
    }

    // Upload to Firebase
    try {
      List<int> byteData = base64Decode(imageBytes);
      Uint8List uint8List = Uint8List.fromList(byteData);
      final imageStorageRef = FirebaseStorage.instance
          .ref()
          .child('algo_images')
          .child('${initialAlgoData.id}.jpg');

      // upload image to firebase
      await imageStorageRef.putData(uint8List);
      imageURL = await imageStorageRef.getDownloadURL();
    } catch (e) {
      scaffoldMessengerContext.clearSnackBars();
      scaffoldMessengerContext.showSnackBar(
        snackBar(
          color: googleRed,
          icon: Icons.error_outline_outlined,
          subtitle: e.toString(),
          title: "Something went wrong!",
        ),
      );

      // If uploading new image failed then return the previous
      // image to the database:
      List<int> byteData = base64Decode(initialAlgoData.image);
      Uint8List uint8List = Uint8List.fromList(byteData);
      final imageStorageRef = FirebaseStorage.instance
          .ref()
          .child('algo_images')
          .child('${initialAlgoData.id}.jpg');

      // upload image to firebase
      await imageStorageRef.putData(uint8List);
      imageURL = await imageStorageRef.getDownloadURL();
      return false;
    }
  }

  // Delete all tags
  try {
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "algo_id": initialAlgoData.id,
    });
    await http.delete(
      nodeUri('delete_all_tags'),
      headers: headers,
      body: body,
    );
  } catch (e) {
    scaffoldMessengerContext.clearSnackBars();
    scaffoldMessengerContext.showSnackBar(
      snackBar(
        color: googleRed,
        icon: Icons.error_outline_outlined,
        subtitle: e.toString(),
        title: "Something went wrong!",
      ),
    );
    return false;
  }

  // Loop add new tags
  for (Tag tag in tags) {
    try {
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        "algo_id": initialAlgoData.id,
        "tag_id": tag.tagId,
      });
      await http.post(
        nodeUri('add_tag'),
        headers: headers,
        body: body,
      );
    } catch (e) {
      scaffoldMessengerContext.clearSnackBars();
      scaffoldMessengerContext.showSnackBar(
        snackBar(
          color: googleRed,
          icon: Icons.error_outline_outlined,
          subtitle: e.toString(),
          title: "Something went wrong!",
        ),
      );
      return false;
    }
  }

  // Patch general data
  try {
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "title": title,
      "code": code,
      "description": description,
      "photo": imageURL,
      "api": isPython ? 1 : 0,
      "algo_id": initialAlgoData.id,
    });
    await http.patch(
      nodeUri('update'),
      headers: headers,
      body: body,
    );
  } catch (e) {
    scaffoldMessengerContext.clearSnackBars();
    scaffoldMessengerContext.showSnackBar(
      snackBar(
        color: googleRed,
        icon: Icons.error_outline_outlined,
        subtitle: e.toString(),
        title: "Something went wrong!",
      ),
    );
    return false;
  }

  // Update local data.
  ref.read(dataManagerProvider).updateSingleData(
      id: initialAlgoData.id,
      newData:  AlgoData(
        id: initialAlgoData.id,
        title: title,
        upVotes: initialAlgoData.upVotes,
        downVotes: initialAlgoData.downVotes,
        datePosted: initialAlgoData.datePosted,
        image: imageURL,
        description: description,
        isBookmarked: initialAlgoData.isBookmarked,
        api: isPython ? 1 : 0,
        code: code,
        userCreator: initialAlgoData.userCreator,
        creatorName: initialAlgoData.creatorName,
        creatorSurname: initialAlgoData.creatorSurname,
        creatorImageURL: initialAlgoData.creatorImageURL,
        tags: tags,
        userVote: initialAlgoData.userVote,
      ));

  // Only if every step has been successfully completed can we return true.
  return true;
}
