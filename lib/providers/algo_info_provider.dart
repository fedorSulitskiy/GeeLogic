import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/helpers/get_user_details/get_user_details.dart';
import 'package:frontend/models/algo_data.dart';
import 'package:frontend/helpers/uri_parser/uri_parse.dart';

final _firebase = FirebaseAuth.instance;

/// The [fetchData] function sends a POST request to a specified endpoint with
/// the following parameters: [offset], [orderCondition], [apiCondition],
/// [algoId] and required [endpoint], and returns a [Map] with two keys:
/// [results] and [count]. This function can be used for getting all algorithms
/// satisfying set conditions or a single algorithm by ID.
///
/// The [results] key maps to a [List] of [AlgoData] objects that are parsed from
/// the [rawData] variable.
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
          "user_id": _firebase.currentUser!.uid,
          "offset": offset,
          "order_condition": orderCondition,
          "api_condition": apiCondition,
        })
      // Body for endpoint 'show_by_id', used by search widget to get a single
      // algorithm
      : json.encode({
          "user_id": _firebase.currentUser!.uid,
          "algo_id": algoId,
        });

  // generalData is a JSON object that contains two keys, 'results' and 'totalCount'
  // which correspond to a list of data items returned by the backend and the total
  // number of data items that satisfy the criteria of the backend request respectively.
  final generalData = await http.post(
    nodeUri(endpoint),
    headers: headers,
    body: body,
  );

  /// The [rawData] variable is a [List] of [dynamic] JSON values that are the raw
  /// data returned from the backend. It is raw since the [dynamic] type values
  /// are not yet converted to [AlgoData] objects.
  final List rawData = endpoint == 'show'
      ? jsonDecode(generalData.body)['results']
      : jsonDecode(generalData.body);

  /// The [countOfTotalData] variable is an [int] that represents the total number
  /// of algorithms that satisfy the criteria of the backend request.
  final int countOfTotalData =
      endpoint == 'show' ? jsonDecode(generalData.body)['totalCount'] : 1;

  /// The [data] variable is a [List] of [AlgoData] objects that are parsed from
  /// the [rawData] variable.
  final data = await Future.wait(
    rawData.map((e) async {
      // Get the details of the creator of the algorithm
      final userDetails = await getUserDetails(e['user_creator']);

      return AlgoData.fromJson(e, userDetails);
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
///  - `params` (String): The [params] parameter is a string that is an encoded JSON file
/// that contains the following keys: [offset], [orderCondition], and [apiCondition].
///
/// Keys:
///
///   - `offset` (int): used to implement pagination
///
///   - `orderCondition` (String):
///     Potential order conditions:
///
///       * 'date_created'
///       * 'up_votes'
///       * 'down_votes'
///       * 'up_votes - down_votes'
///     All need 'ASC' or 'DESC' specified after the condition
///
///  - `apiCondition` (String):
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

  // Fetch data from the backend
  final algosFromBackend = await fetchData(
    offset: offset,
    orderCondition: orderCondition,
    apiCondition: apiCondition,
    endpoint: 'show',
  );

  // Store said data in the data manager provider which assists with updating
  // the data in the catalogue screen instantly, namely bookmark status.
  final dataManager = ref.read(dataManagerProvider);
  dataManager.updateDataList(algosFromBackend['results']);

  return algosFromBackend;
});

/// The [singleAlgorithmProvider] is a [Provider.family] that provides a
/// [Map] of [AlgoData] objects under key [results] and total length of 1
/// under key [count], since only one result is returned.
///
/// This provider is used by the search widget to get a single algorithm.
///
/// Args:
///   - `algoId` (String): The [algoId] parameter is a string that represents the ID of an algorithm.
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
  final List<AlgoData> _dataList = [];

  /// The getter returns the data list.
  List<AlgoData> get dataList => _dataList;

  /// The function returns a single data item from the data list based on its ID.
  AlgoData getDataItem(id) =>
      _dataList.singleWhere((element) => element.id == id);

  /// The function updates the data list with new data and notifies listeners.
  ///
  /// Args:
  ///   - `newDataList` (List<AlgoData>): The parameter [newDataList] is a List of objects of type
  /// [AlgoData].
  void updateDataList(List<AlgoData> newDataList) {
    // Create a map of existing ids
    var existingIds = Map.fromEntries(_dataList.map((d) => MapEntry(d.id, d)));

    // Add new data, skipping any that have duplicate ids
    for (var newData in newDataList) {
      if (!existingIds.containsKey(newData.id)) {
        _dataList.add(newData);
        existingIds[newData.id] = newData;
      }
    }
    notifyListeners();
  }

  /// The function updates a single data item in a list based on its ID.
  ///
  /// Args:
  ///   - `id` (int): The id parameter is an integer that represents the unique identifier of the data that
  /// needs to be updated.
  ///   - `newData` (AlgoData): The [newData] parameter is an object of type [AlgoData] that contains the
  /// updated data that needs to be assigned to the element with the specified [id] in the [_dataList].
  void updateSingleData({required int id, required AlgoData newData}) {
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
