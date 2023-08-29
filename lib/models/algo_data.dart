import 'dart:convert' show json;

import 'package:intl/intl.dart';

import 'package:frontend/models/tag.dart';

final formatter = DateFormat("dd MMM yyyy");

/// A class that represents the data of an algorithm.
class AlgoData {
  AlgoData({
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
    required this.creatorName,
    required this.creatorSurname,
    required this.creatorImageURL,
    required this.tags,
    required this.userVote,
  });

  final int id;
  final String title;
  int upVotes;
  int downVotes;
  final String datePosted;
  final String image;
  final String description;
  bool isBookmarked;
  final int api;
  final String code;
  final String userCreator;
  final String creatorName;
  final String creatorSurname;
  final String creatorImageURL;
  final List<Tag> tags;
  int? userVote;

  /// Getter returning the net votes of the algorithm, subtracting negative from
  /// the negative votes.
  int get netVotes {
    return upVotes - downVotes;
  }

  /// Getter returning the formatted date as a [String] in the format of
  /// "dd MMM yyyy", equivalent to "01 Jan 2021".
  String get formattedDate {
    DateTime dateTime = DateTime.parse(datePosted);
    return formatter.format(dateTime);
  }

  /// The function [AlgoData.fromJson] takes in a JSON object and user details, decodes the tags from
  /// the JSON object, and returns an instance of [AlgoData] with the decoded tags and other properties.
  /// 
  /// Args:
  ///   - `jsonObject` (Map<String, dynamic>): A map containing the JSON data for the [AlgoData] object.
  ///   - `userDetails` (Map<String, dynamic>): A map containing details of the user who created the
  /// [AlgoData]. It includes the user's image URL, name, and surname.
  /// 
  /// Returns:
  ///   - an instance of the [AlgoData] class.
  factory AlgoData.fromJson(
      Map<String, dynamic> jsonObject, dynamic userDetails) {
    // Tags are returned as a list of JSON objects, however since backend
    // returns a string, it needs to be decoded first.
    // End result should be a [List<Tag>] object.
    final List<dynamic> rawTags = json.decode(jsonObject['tags'] as String);
    final List<Tag> tagsList =
        rawTags.map<Tag>((tag) => Tag.fromJson(tag)).toList();

    return AlgoData(
      id: jsonObject['id'],
      title: jsonObject['title'],
      upVotes: jsonObject['upVotes'],
      downVotes: jsonObject['downVotes'],
      datePosted: jsonObject['datePosted'],
      image: jsonObject['image'],
      description: jsonObject['description'],
      isBookmarked: jsonObject['isBookmarked'] == 1 ? true : false,
      api: jsonObject['api'],
      code: jsonObject['code'],
      userCreator: jsonObject['user_creator'],
      tags: tagsList,
      userVote: jsonObject['userVote'],
      creatorImageURL: userDetails['imageURL'],
      creatorName: userDetails['name'],
      creatorSurname: userDetails['surname'],
    );
  }
}
