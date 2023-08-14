import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/models/algo_data.dart';

/// The function [fetchData] fetches data from a node API and returns a map containing the fetched data
/// and the count of total data.
/// 
/// Args:
///   offset (int): The [offset] parameter is used to specify the starting index of the data to be
/// fetched. It is used to implement pagination, where each page of data is fetched by specifying the
/// offset value. For example, if [offset] is 0, it will fetch the first page of data.
/// 
/// Returns:
///   The function [fetchData] returns a [Future] that resolves to a [Map<String, dynamic>] where the
/// key [results] contains a [List<dynamic>] object of all data regarding algorithms on current page 
/// and [count] contains an [int] that represents the total count of items in the database matching
/// the intial query.
Future<Map<String, dynamic>> fetchData(int offset) async {
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
  final generalBody = json.encode({"offset": offset});
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
final allAlgorithmsProvider = FutureProvider.family<Map<String, dynamic>,int>((ref, offset) async {
  return await fetchData(offset);
});
