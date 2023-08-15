import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/models/algo_data.dart';

/// Returns parsed Uri of node API with end point specified
/// TODO: implement for all apis once deployed
Uri nodeUri(String endpoint) {
  return Uri.parse('http://localhost:3000/node_api/$endpoint');
}

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
  final int countOfTotalData = endpoint == 'show' 
      ? jsonDecode(generalData.body)['totalCount'] 
      : 1;

  /// The [data] variable is a [List] of [AlgoData] objects that are parsed from
  /// the [rawData] variable.
  ///
  /// For each element in [rawData], the function [getTags] is called to get the
  /// tags corresponding to that algorithm.
  final data = await Future.wait(
    rawData.map((e) async {
      final tags = await getTags(e['algo_id']);

      return AlgoData(
        id: e['algo_id'],
        title: e['title'],
        upVotes: e['up_votes'],
        downVotes: e['down_votes'],
        datePosted: e['date_created'],
        image: e['photo'],
        description: e['description'],
        isBookmarked: false,
        api: e['api'],
        code: e['code'],
        userCreator: e['user_creator'],
        tags: tags,
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

  return await fetchData(
    offset: offset,
    orderCondition: orderCondition,
    apiCondition: apiCondition,
    endpoint: 'show',
  );
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
