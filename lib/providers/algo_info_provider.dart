import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/helpers/uri_parser/uri_parse.dart';

final _firebase = FirebaseAuth.instance;

/// The function [getTags] sends a POST request to a specified endpoint with an algorithm ID and
/// returns a list of tags corresponding to that algorithm.
///
/// Args:
///   algoId (String): The [algoId] parameter is a string that represents the ID of an algorithm.
///
/// Returns:
///   a [Future] object that resolves to a [List] of [dynamic] values.
Future<List<dynamic>> getTags(int algoId) async {
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({"algo_id": algoId});
  final tagsData = await http.post(
    nodeUri('show_tags'),
    headers: headers,
    body: body,
  );
  return jsonDecode(tagsData.body);
}

/// The function [isBookmarked] sends a POST request to a specified endpoint with an algorithm ID and
/// returns a boolean value that represents whether the algorithm is bookmarked by the user.
Future<bool> isBookmarked(int algoId) async {
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    "algo_id": algoId,
    "user_id": _firebase.currentUser!.uid,
  });
  final isAlgorithmBookmarked = await http.post(
    nodeUri('find_bookmark'),
    headers: headers,
    body: body,
  );
  return jsonDecode(isAlgorithmBookmarked.body);
}

/// The function [getUserVote] retrieves the user's vote for a specific algorithm from a server.
/// 
/// Args:
///   algoId (int): The algoId parameter is an integer that represents the ID of an algorithm.
/// 
/// Returns:
///   a Future<int?>, which means it is returning a Future that may contain an integer value or null.
///   Where null indicates that current user has not voted for this algorithm, positive one (1) indicates they
///   have upvoted for this algorithm and negative one (-1) indicates they have downvoted.
Future<int?> getUserVote(int algoId) async {
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    "algo_id": algoId,
    "user_id": _firebase.currentUser!.uid,
  });
  final userVote = await http.post(
    nodeUri('find_vote'),
    headers: headers,
    body: body,
  );
  if (userVote.body.isEmpty) {
    return null;
  }
  return jsonDecode(userVote.body)['vote'];
}

/// The function retrieves a user document from the Firestore database based on the provided user ID.
/// 
/// Args:
///   userId (String): The [userId] parameter is a string that represents the unique identifier of a
/// user.
/// 
/// Returns:
///   a `Future<dynamic>`, with keys `name`, `surname`, `bio`, `email` and `imageURL`
Future<dynamic> getUserCreator(String userId) async {
  return await FirebaseFirestore.instance.collection('users').doc(userId).get();
}

/// The [fetchData] function sends a POST request to a specified endpoint with
/// the following parameters: [offset], [orderCondition], [apiCondition],
/// [algoId] and required [endpoint], and returns a [Map] with two keys:
/// [results] and [count]. This function can be used for getting all algorithms
/// satisfying set conditions or a single algorithm by ID.
///
/// The [results] key maps to a [List] of [AlgoData] objects that are parsed from
/// the [rawData] variable. For each element in [rawData], the function [getTags]
/// is called to get the tags corresponding to that algorithm.
///
/// The [count] key maps to an [int] that represents the total number of algorithms
/// that satisfy the criteria of the backend request.
Future<Map<String, dynamic>> fetchData({
  int? offset,
  String? orderCondition,
  String? apiCondition,
  int? algoId,
  required String endpoint,
}) async {
  // First send a request to the node API to get the general data about algorithm
  final headers = {'Content-Type': 'application/json'};
  final body = endpoint == 'show'
      // Body for endpoint 'show', used by catalogue content widget to get all
      // algorithms conditionally
      ? json.encode({
          "offset": offset,
          "orderCondition": orderCondition,
          "apiCondition": apiCondition,
        })
      // Body for endpoint 'show_by_id', used by search widget to get a single
      // algorithm
      : json.encode({
          "algo_id": algoId,
        });
  final generalData = await http.post(
    nodeUri(endpoint),
    headers: headers,
    body: body,
  );

  /// The [rawData] variable is a [List] of [dynamic] JSON values that are the raw
  /// data returned from the backend.
  final List rawData = endpoint == 'show'
      ? jsonDecode(generalData.body)['results']
      : jsonDecode(generalData.body);

  /// The [countOfTotalData] variable is an [int] that represents the total number
  /// of algorithms that satisfy the criteria of the backend request.
  final int countOfTotalData =
      endpoint == 'show' ? jsonDecode(generalData.body)['totalCount'] : 1;

  /// The [data] variable is a [List] of [AlgoData] objects that are parsed from
  /// the [rawData] variable.
  ///
  /// For each element in [rawData], the function [getTags] is called to get the
  /// tags corresponding to that algorithm.
  final data = await Future.wait(
    rawData.map((e) async {
      // Get the tags corresponding to the algorithm
      final tags = await getTags(e['algo_id']);
      // Get the details of the creator of the algorithm
      final userDetails = await getUserCreator(e['user_creator']);
      // Check if the algorithm is bookmarked by the current user
      final isAlgoBookmarked = await isBookmarked(e['algo_id']);
      // Check if the user has voted on the algorithm and if so, what was the vote
      final userVote = await getUserVote(e['algo_id']);

      return AlgoData(
        id: e['algo_id'],
        title: e['title'],
        upVotes: e['up_votes'],
        downVotes: e['down_votes'],
        datePosted: e['date_created'],
        image: e['photo'],
        description: e['description'],
        isBookmarked: isAlgoBookmarked,
        api: e['api'],
        code: e['code'],
        userCreator: e['user_creator'],
        creatorName: userDetails['name'],
        creatorSurname: userDetails['surname'],
        creatorImageURL: userDetails['imageURL'],
        tags: tags,
        userVote: userVote,
      );
    }).toList(),
  );

  // create a map with two keys: 'results' and 'count'
  return {"results": data, "count": countOfTotalData};
}

/// The [allAlgorithmsProvider] is a [FutureProvider.family] that provides a
/// [Map] of [AlgoData] objects under key [results] and total length of all
/// results satisfying the criteria of the backend request under key [count].
///
/// Args:
///
///  params (String): The [params] parameter is a string that is an encoded JSON file
/// that contains the following keys: [offset], [orderCondition], and [apiCondition].
///
/// Keys:
///
///   offset (int): used to implement pagination
///
///   orderCondition (String):
///     Potential order conditions:
///
///       * 'date_created'
///       * 'up_votes'
///       * 'down_votes'
///       * 'up_votes - down_votes'
///     All need 'ASC' or 'DESC' specified after the condition
///
///  apiCondition (String):
///     Potential api conditions:
///
///       * '0'    - javascript
///       * '1'    - python
///       * '0, 1' - javascript and python
final allAlgorithmsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, params) async {
  // NOTE: params is a string that is an encoded JSON file.
  // I could not figure out how to pass a custom file as a parameter and
  // keep this code working.
  final decodedParams = json.decode(params);
  final offset = decodedParams['offset'];
  final apiCondition = decodedParams['apiCondition'];
  final orderCondition = decodedParams['orderCondition'];

  final algosFromBackend = await fetchData(
    offset: offset,
    orderCondition: orderCondition,
    apiCondition: apiCondition,
    endpoint: 'show',
  );

  return algosFromBackend;
});

/// The [singleAlgorithmProvider] is a [FutureProvider.family] that provides a
/// [Map] of [AlgoData] objects under key [results] and total length of 1
/// under key [count], since only one result is returned.
///
/// This provider is used by the search widget to get a single algorithm.
///
/// Args:
///   algoId (String): The [algoId] parameter is a string that represents the ID of an algorithm.
final singleAlgorithmProvider =
    Provider.family<Future<Map<String, dynamic>>, String>((ref, algoId) async {
  // NOTE: params is a string that is an encoded JSON file.
  // I could not figure out how to pass a custom file as a parameter and
  // keep this code working.
  return await fetchData(
    algoId: int.parse(algoId),
    endpoint: 'show_by_id',
  );
});

/// [DataManager] is a [ChangeNotifier] class that allows one to manipulate data
/// loaded by the [allAlgorithmsProvider] as if it was a [StateNotifier]. This is used
/// in the project to update the isBookmarked field of an algorithm, allowing for 
/// synchronous update of the bookmark icon in the [AlgoCard] widget and [TitleElement].
class DataManager extends ChangeNotifier {
  List<AlgoData> _dataList = [];

  List<AlgoData> get dataList => _dataList;

  /// The function updates the data list with new data and notifies listeners.
  /// 
  /// Args:
  ///   newDataList (List<AlgoData>): The parameter [newDataList] is a List of objects of type
  /// [AlgoData].
  void updateDataList(List<AlgoData> newDataList) {
    _dataList = newDataList;
    notifyListeners();
  }

  /// The function updates a single data item in a list based on its ID.
  /// 
  /// Args:
  ///   id (int): The id parameter is an integer that represents the unique identifier of the data that
  /// needs to be updated.
  ///   newData (AlgoData): The [newData] parameter is an object of type [AlgoData] that contains the
  /// updated data that needs to be assigned to the element with the specified [id] in the [_dataList].
  void updateSingleData(int id, AlgoData newData) {
    final index = _dataList.indexWhere((element) => element.id == id);
    if (index != -1) {
      _dataList[index] = newData;
      notifyListeners();
    }
  }
}

/// Provides a [DataManager] object that can be used to manipulate data loaded by the
/// [allAlgorithmsProvider] as if it was managed by a [StateNotifier].
final dataManagerProvider = ChangeNotifierProvider((ref) => DataManager());
