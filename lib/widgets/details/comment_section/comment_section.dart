import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/widgets/details/comment_section/comment.dart';

import 'package:frontend/widgets/details/comment_section/comment_input_bar.dart';

final _firebase = FirebaseAuth.instance;

/// The widget that displays the comments section of the algorithm details screen.
/// It is composed of two main parts: the input bar and the comments.
///
/// The input bar is used to add a new comment to the database, while the comments
/// are fetched from the database and displayed in a list.
///
/// The comments are fetched from the database using a stream, which is a realtime
/// connection to the database. This means that whenever a new comment is added to
/// the database, it will be automatically fetched and displayed in the comments list.
class CommentSection extends StatefulWidget {
  const CommentSection({super.key, required this.algoId});

  final int algoId;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// The [_addComment] function adds a comment to a Firestore collection with the username, text, and
  /// timestamp.
  ///
  /// Args:
  ///   - `comment` (String): The [comment] parameter is a string that represents the text of the comment
  /// that will be added to the Firestore database.
  void _addComment(String comment) async {
    await _firestore
        .collection('comments')
        .doc(widget.algoId.toString())
        .collection('comments')
        .add({
      'username': _firebase.currentUser!.uid,
      'text': comment,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _commentController.clear();
  }

  /// The function [_getUserDetails] retrieves user details from a Firestore collection based on the
  /// provided user ID.
  ///
  /// Args:
  ///   - `userId` (String): The [userId] parameter is a string that represents the unique identifier of a
  /// user. It is used to retrieve the user details from the Firestore database.
  ///
  /// Returns:
  ///   - The function [_getUserDetails] returns a [Future] that resolves to a [Map<String, dynamic>].
  Future<Map<String, dynamic>> _getUserDetails(String userId) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userSnapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // COMMENT INPUT BAR
        CommentInputBar(
          addComment: _addComment,
          commentController: _commentController,
        ),

        // COMMENT BODY
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('comments')
              .doc(widget.algoId.toString())
              .collection('comments')
              .orderBy('timestamp')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Main body of comments being fetched from the database, firebase.
            return Column(
              children: List.generate(
                snapshot.data!.docs.length,
                (index) {
                  var comment = snapshot.data!.docs[index];

                  // For each comment user details must be fetched from the database,
                  // to show their name and profile picture.
                  return FutureBuilder<Map<String, dynamic>>(
                    future: _getUserDetails(comment['username']),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return _WaitingComment();
                      } else if (userSnapshot.hasError) {
                        return const Text('Error fetching user details');
                      }

                      Map<String, dynamic> user = userSnapshot.data!;

                      var commentText = comment['text'];

                      // Return the comment widget with the user details and comment text.
                      return Comment(
                        text: commentText,
                        user: user,
                        timestamp: comment['timestamp'],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Used to provide a placeholder for the comments while they are being fetched.
class _WaitingComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 35.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey[400],
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100.0,
                    height: 16.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Container(
                width: 200.0,
                height: 16.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
