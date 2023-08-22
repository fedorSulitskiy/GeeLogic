import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/helpers/uri_parser/uri_parse.dart';

/// The function [loadHTMLString] sends a POST request to python API with a code string as the
/// request body and returns the response body as a Future. The code string is the python code
/// that the backend will execute and return the resulting map widget as an HTML string.
///
/// Args:
///   uri (Uri): The [uri] parameter is of type [Uri] and represents the URL where the HTTP POST request
/// will be sent to.
///   codeString (String): The [codeString] parameter is a string that represents the python code
/// that will be executed in the backend.
///
/// Returns:
///   a [Future<String>], which means it will eventually return a [String] value.
Future<String> loadHTMLString(Uri uri, String codeString) async {
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  final body = {'code': codeString};
  final http.Response response = await http.post(uri, headers: headers, body: body);
  return response.body;
}

// class MapWidgetHTMLCodeNotifier extends StateNotifier<String> {
//   MapWidgetHTMLCodeNotifier() : super('');

//   Future loadData(Uri uri, String codeString) async {
//     state = await loadHTMLString(uri, codeString);
//   }
// }

// final mapWidgetHTMLCodeProvider =
//     StateNotifierProvider<MapWidgetHTMLCodeNotifier, String>((ref) {
//   return MapWidgetHTMLCodeNotifier();
// });

final mapWidgetCodeProvider =
    FutureProvider.family<String, String>((ref, params) async {
  final decodedParams = json.decode(params);
  final String uri = decodedParams['uri'];
  final String code = decodedParams['code'];

  return await loadHTMLString(pythonUri(uri), code);
});
