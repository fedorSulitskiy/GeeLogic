import 'package:intl/intl.dart';

final formatter = DateFormat("dd MMM yyyy");

class AlgoCardData {
  const AlgoCardData({
    required this.id,
    required this.title,
    required this.upVotes,
    required this.downVotes,
    required this.datePosted,
    required this.image,
    required this.description,
    required this.isBookmarked,
  });

  final String id;
  final String title;
  final int upVotes;
  final int downVotes;
  final DateTime datePosted;
  final String image;
  final String description;
  final bool isBookmarked;

  int get netVotes {
    return upVotes - downVotes;
  }

  String get formattedDate {
    return formatter.format(datePosted);
  }
}