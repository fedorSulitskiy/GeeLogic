import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:frontend/widgets/input/input_content.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future uploadLogic({
  required BuildContext context,
  required String title,
  required String description,
  required List<dynamic> tags,
  required String code,
  required String mapCode,
}) async {
  //**
  // UPLOAD DATA --> get id
  // GET IMAGE FROM API --> get image bytes
  // UPLOAD IMAGE TO FIREBASE <-- use the id and image bytes
  // UPLOAD IMAGE LINK TO SQL DB
  // UPLOAD TAGS
  // */

  final firebase = FirebaseAuth.instance;
  final currentUser = firebase.currentUser;
  final dynamic nodeResponse;
  final http.Response thumbnailResponse;
  final String imageBytes;
  final String imageURL;
  final scaffoldMessengerContext = ScaffoldMessenger.of(context);

  // Error message
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

  // Upload data to SQL db
  try {
    final nodeUrl = Uri.parse('http://localhost:3000/node_api/create');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'title': title,
      "py_code": code,
      "description": description,
      "user_creator": currentUser!.uid,
    });
    nodeResponse = await http.post(nodeUrl, headers: headers, body: body);
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
    return;
  }

  // Get id of uploaded algorithm
  final int algoId = jsonDecode(nodeResponse.body)["insertId"];

  // Get image
  try {
    final thumbnailUrl =
        Uri.parse('http://192.168.99.149:3002/thumbnail_api/get_thumbnail');
    Map<String, String> body = {
      'data': mapCode,
    };
    thumbnailResponse = await http.post(thumbnailUrl, body: body);
    imageBytes = thumbnailResponse.body;
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
    return;
  }

  // Upload to Firebase
  try {
    List<int> byteData = base64Decode(imageBytes);
    Uint8List uint8List = Uint8List.fromList(byteData);
    final imageStorageRef = FirebaseStorage.instance
        .ref()
        .child('algo_images')
        .child('$algoId.jpg');
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
    return;
  }

  // Upload image data to SQL db
  try {
    final imageUrl = Uri.parse('http://localhost:3000/node_api/add_image');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({"algo_id": algoId, "photo": imageURL});
    await http.patch(imageUrl, headers: headers, body: body);
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
    return;
  }

  // Upload tags data to SQL db
  try {
    for (var tag in tags) {
      final tagUrl = Uri.parse('http://localhost:3000/node_api/add_tag');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({"algo_id": algoId, "tag_id": tag["tag_id"]});
      await http.post(tagUrl, headers: headers, body: body);
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
    return;
  }
}
