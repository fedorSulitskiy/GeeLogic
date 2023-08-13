import 'package:intl/intl.dart';

final formatter = DateFormat("dd MMM yyyy");

class AlgoData {
  const AlgoData({
    required this.id,
    required this.title,
    required this.upVotes,
    required this.downVotes,
    required this.datePosted,
    required this.image,
    required this.description,
    required this.isBookmarked,
    required this.api,
    required this.code,
    required this.userCreator,
    required this.tags,
  });

  final int id;
  final String title;
  final int upVotes;
  final int downVotes;
  final String datePosted;
  final String image;
  final String description;
  final bool isBookmarked;
  final int api;
  final String code;
  final String userCreator;
  final List<dynamic> tags;

  int get netVotes {
    return upVotes - downVotes;
  }

  String get formattedDate {
    DateTime dateTime = DateTime.parse(datePosted);
    return formatter.format(dateTime);
  }
}
