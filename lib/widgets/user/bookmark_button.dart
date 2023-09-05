import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/helpers/uri_parser/uri_parse.dart';
import 'package:frontend/app_theme.dart';

final _firebase = FirebaseAuth.instance;

/// Button found at the corner of [UserAlogirthm] widget, which on press
/// removes the bookmark from the database.
///
/// When pressed it doesn't immediate remove the bookmark, it leaves the
/// algorithm on the screen allowing user to undo the change in case they
/// pressed the button accidentally.
class BookmarkButton extends StatefulWidget {
  const BookmarkButton({super.key, required this.algoId});

  final int algoId;

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool isBookmarked = true;

  @override
  Widget build(BuildContext context) {
    /// Custom [SnackBar] to display communication with the user, regarding validity
    /// of their inputs.
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

    return IconButton(
      icon: isBookmarked
          ? const Icon(Icons.bookmark)
          : const Icon(Icons.bookmark_border),
      onPressed: () async {
        // Establish context for scaffoldMessenger before async gaps
        final scaffoldMessengerContext = ScaffoldMessenger.of(context);

        // Manipulate data on the server
        if (isBookmarked) {
          // Delete bookmark if it exists
          final headers = {'Content-Type': 'application/json'};
          final body = json.encode({
            "algo_id": widget.algoId,
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
            "algo_id": widget.algoId,
            "user_id": _firebase.currentUser!.uid,
          });
          await http.post(
            nodeUri('bookmark_algo'),
            headers: headers,
            body: body,
          );
        }

        // Communication with user
        scaffoldMessengerContext.clearSnackBars();
        scaffoldMessengerContext.showSnackBar(
          snackBar(
            color: isBookmarked
                ? GeeLogicColourScheme.red
                : GeeLogicColourScheme.green,
            icon: isBookmarked ? Icons.bookmark_outline : Icons.bookmark,
            subtitle: isBookmarked
                ? "To undo change click on the bookmark until it's filled!"
                : "To remove bookmark click on the bookmark until it's empty!",
            title: isBookmarked ? "Bookmark removed" : "Bookmark returned",
          ),
        );

        // Update bookmark status
        setState(() {
          isBookmarked = !isBookmarked;
        });
      },
    );
  }
}
