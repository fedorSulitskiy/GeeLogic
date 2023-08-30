import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat("dd MMM yyyy");

/// The widget that displays a single comment in the comments section of the algorithm details screen.
class Comment extends StatelessWidget {
  const Comment({
    super.key,
    required this.user,
    required this.text,
    required this.timestamp,
  });

  final String text;
  final Map<String, dynamic> user;
  final Timestamp timestamp;

  /// The function [_getFormattedDate] takes a [TimeStamp] object, extracts the seconds and nanoseconds,
  /// creates a [DateTime] object, and formats it to the desired format. The original timestamp is recieved from
  /// the Firebase server.
  ///
  /// Args:
  ///   - `timestamp` (TimeStamp): The [timestamp] parameter is a fireabase [TimeStamp] that represents a timestamp in the
  /// format `Timestamp(seconds=1234567890, nanoseconds=123456789)`.
  ///
  /// Returns:
  ///   - The method is returning a formatted date string, formatted to the format `dd MMM yyyy`.
  String _getFormattedDate(Timestamp timestamp) {
    // Convert the [TimeStamp] objec to a [DateTime] object.
    final DateTime dateTime = timestamp.toDate();

    // Format the DateTime object to the desired format
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 35.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(user['imageURL']),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${user['name']}",
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                    ),
                    Text(
                      user['surname'],
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      _getFormattedDate(timestamp),
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontSize: 12.0,
                          ),
                    ),
                  ],
                ),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
