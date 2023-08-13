import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/models/algo_data.dart';

/// The [allAlgorithmsProvider] is a [FutureProvider] that provides a list of [AlgoData] objects. It
/// uses the [http] package to make HTTP requests to a Node.js API and fetches data about algorithms.
final allAlgorithmsProvider = FutureProvider<List<AlgoData>>((ref) async {
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

  final generalData = await http.get(nodeUri('show'));
  final List rawData = jsonDecode(generalData.body);

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

  return data;
});
