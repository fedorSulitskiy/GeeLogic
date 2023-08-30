import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/screens/loading_screen.dart';
import 'package:frontend/models/algo_data.dart';
import 'package:frontend/providers/algo_info_provider.dart';
import 'package:frontend/providers/input_code_providers.dart';
import 'package:frontend/providers/input_tags_provider.dart';
import 'package:frontend/screens/edit_screen.dart';
import 'package:frontend/helpers/uri_parser/uri_parse.dart';
import 'package:frontend/widgets/_archive/login_details.dart';
import 'package:frontend/widgets/input/input_content.dart';

/// Buttons for editing and deleting the algorithm, found in the corner of
/// [UserAlgorithm] widget.
class EditAndDeleteButtons extends ConsumerStatefulWidget {
  const EditAndDeleteButtons({
    super.key,
    required this.data,
    required this.removeFunction,
  });

  final AlgoData data;
  final Function(int) removeFunction;

  @override
  ConsumerState<EditAndDeleteButtons> createState() =>
      _EditAndDeleteButtonsState();
}

class _EditAndDeleteButtonsState extends ConsumerState<EditAndDeleteButtons> {
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

    // Use data from local provider to display to user.
    final AlgoData data =
        ref.watch(dataManagerProvider).getDataItem(widget.data.id);

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
        child: _isDeleting
            ? Row(
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
                      final scaffoldMessengerContext =
                          ScaffoldMessenger.of(context);

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
                            "algo_id": widget.data.id,
                          });
                          await http.delete(
                            nodeUri('remove'),
                            headers: headers,
                            body: body,
                          );

                          // Remove algo from the list of algos
                          widget.removeFunction(widget.data.id);

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
              )
            : Container(height: 26),
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
              onPressed: () async {
                // Establish a context before async gap
                final navContext = Navigator.of(context);

                // Start loading animation
                navContext.push(
                  MaterialPageRoute(
                    builder: (ctx) => const StarLoadingScreen(),
                  ),
                );

                // Set the tags seleted to relevant ones. This is very important
                // since unlike the other inputs, the tags input is managed via
                // a provider, and not a controller.
                ref
                    .read(selectedTagsProvider.notifier)
                    .getSelectedTags(data.tags);

                // Set the api type to relevant one. It is also determined by
                // a controller and hence needs to be set here.
                ref
                    .read(apiLanguageProvider.notifier)
                    .setLanguage(data.api == 1 ? true : false);

                // Set the validity of the code to true by default since it is
                // the same old code.
                ref.read(isValidProvider.notifier).setValid(true);

                // Navigate to the edit screen
                navContext.pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => EditScreen(data: data),
                  ),
                );
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
