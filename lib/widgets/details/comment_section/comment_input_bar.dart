import 'package:flutter/material.dart';

/// The widget that displays a single comment in the comments section of the algorithm details screen.
class CommentInputBar extends StatelessWidget {
  const CommentInputBar({
    super.key,
    required this.addComment,
    required this.commentController,
  });

  final void Function(String) addComment;
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 40.0,
        left: 40.0,
        top: 0.0,
        bottom: 10.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                addComment(commentController.text);
              }
            },
          ),
        ],
      ),
    );
  }
}
