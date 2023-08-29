import 'package:cloud_firestore/cloud_firestore.dart';

/// The function retrieves a user document from the Firestore database based on the provided user ID.
/// Mostly used to capture details of the user that created an algorithm.
///
/// Args:
///   userId (String): The [userId] parameter is a string that represents the unique identifier of a
/// user.
///
/// Returns:
///   a `Future<dynamic>`, with keys `name`, `surname`, `bio`, `email` and `imageURL`
Future<dynamic> getUserDetails(String userId) async {
  return await FirebaseFirestore.instance.collection('users').doc(userId).get();
}
