import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/models/algo_data.dart';

/// The [fetchData] function sends a POST request to a specified endpoint with
/// the following parameters: [offset], [orderCondition], and [apiCondition].
/// It then returns a [Map] of [AlgoData] objects under key [results] and total
/// length of all results satisfying the criteria of the backend request under
/// key [count]. 
Future<Map<String, dynamic>> fetchData({
  required int offset,
  required String orderCondition,
  required String apiCondition,
}) async {
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

  final generalHeaders = {'Content-Type': 'application/json'};
  final generalBody = json.encode({
    "offset": offset,
    "orderCondition": orderCondition,
    "apiCondition": apiCondition,
  });
  final generalData = await http.post(
    nodeUri('show'),
    headers: generalHeaders,
    body: generalBody,
  );
  final List rawData = jsonDecode(generalData.body)['results'];
  final int countOfTotalData = jsonDecode(generalData.body)['totalCount'];

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
  );
});
