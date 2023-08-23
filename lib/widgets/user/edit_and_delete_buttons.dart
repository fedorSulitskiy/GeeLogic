import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/helpers/uri_parser/uri_parse.dart';
import 'package:frontend/widgets/_archive/login_details.dart';
import 'package:frontend/widgets/input/input_content.dart';

final _firebase = FirebaseAuth.instance;

/// Buttons for editing and deleting the algorithm, found in the corner of
/// [UserAlgorithm] widget.
class EditAndDeleteButtons extends StatefulWidget {
  const EditAndDeleteButtons({super.key, required this.algoId});

  final int algoId;

  @override
  State<EditAndDeleteButtons> createState() => _EditAndDeleteButtonsState();
}

class _EditAndDeleteButtonsState extends State<EditAndDeleteButtons> {
  // Variable that controls if Delete button is pressed. When its pressed it will
  // as user if they are sure about deleting the algorithm
  bool _isDeleting = false;
  // Variable that controls if the user's mouse cursor is hovering over the Edit button
  bool _editHover = false;
  // Variable that controls if the user's mouse cursor is hovering over the Delete button
  bool _deleteHover = false;
  // Variable that controls if user is confident in their intention to delete
  // an algorithm, it allows the user to undo changes, if they regret last minute,
  // at the Snackbar.
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    TextStyle deleteTextTheme(Color color) {
      return Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: color, fontSize: 18.0);
    }

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
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            // Prevent deletion process
            _deleting = false;

            // Remove deletion confirmation box
            setState(() {
              _isDeleting = false;
            });
          },
        ),
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

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      crossFadeState:
          _isDeleting ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      // Confirmation if the user wants to delete the algorithm
      firstChild: Container(
        padding: const EdgeInsets.only(
          right: 4.0,
          bottom: 0.0,
          top: 4.0,
          left: 8.0,
        ),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: googleRed,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _isDeleting ? Row(
          children: [
            Text(
              'Delete?',
              style: deleteTextTheme(Colors.white),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(4.0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              child: Text(
                'Yes',
                style: deleteTextTheme(Colors.white),
              ),
              onPressed: () {
                // Establish context for scaffoldMessenger before async gaps
                final scaffoldMessengerContext = ScaffoldMessenger.of(context);

                // Initiate deletion procedure
                _deleting = true;

                // Communication with user and Deleting sequence
                scaffoldMessengerContext.clearSnackBars();
                scaffoldMessengerContext
                    .showSnackBar(
                      snackBar(
                        color: googleRed,
                        icon: Icons.delete_forever_outlined,
                        subtitle: "To undo change click UNDO now!",
                        title: "Algorithm deleted",
                      ),
                    )
                    .closed
                    .then((value) async {
                  if (_deleting) {
                    // Remove confirmation box
                    setState(() {
                      _isDeleting = false;
                    });

                    // Delete algo in the database
                    final headers = {'Content-Type': 'application/json'};
                    final body = json.encode({
                      "algo_id": widget.algoId,
                    });
                    await http.delete(
                      nodeUri('remove'),
                      headers: headers,
                      body: body,
                    );

                    // Reset deletion failsafe
                    _deleting = false;
                  }
                });
              },
            ),
            Text('/', style: deleteTextTheme(Colors.white)),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(4.0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              child: Text(
                'No',
                style: deleteTextTheme(Colors.white),
              ),
              onPressed: () {
                // Provide another way to prevent deletion of algorithm
                _deleting = false;

                setState(() {
                  _isDeleting = false;
                });
              },
            ),
          ],
        ) : Container(height: 26),
      ),
      // Edit and Delete buttons
      secondChild: Row(
        children: [
          MouseRegion(
            onEnter: (event) {
              setState(() {
                _editHover = true;
              });
            },
            onExit: (event) {
              setState(() {
                _editHover = false;
              });
            },
            child: IconButton(
              icon: Icon(
                Icons.edit_square,
                color: _editHover ? googleBlue : null,
              ),
              onPressed: () {
                // TODO: send to edit screen
              },
            ),
          ),
          MouseRegion(
            onEnter: (event) {
              setState(() {
                _deleteHover = true;
              });
            },
            onExit: (event) {
              setState(() {
                _deleteHover = false;
              });
            },
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: _deleteHover ? googleRed : null,
              ),
              onPressed: () {
                setState(() {
                  _isDeleting = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
