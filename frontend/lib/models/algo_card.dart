import 'package:intl/intl.dart';

final formatter = DateFormat("dd MMM yyyy");

class AlgoCardData {
  const AlgoCardData({
    required this.id,
    required this.title,
    required this.upVotes,
    required this.downVotes,
    required this.datePosted,
    required this.isFavourite,
    required this.image,
  });

  final String id;
  final String title;
  final int upVotes;
  final int downVotes;
  final DateTime datePosted;
  final bool isFavourite;
  final String image;

  int get netVotes {
    return upVotes - downVotes;
  }

  String get formattedDate {
    return formatter.format(datePosted);
  }
}