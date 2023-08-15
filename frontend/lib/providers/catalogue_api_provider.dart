import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is the provider for the selected API in the catalogue.
class CatalogueSelectedApiNotifier extends StateNotifier<String> {
  CatalogueSelectedApiNotifier() : super("0,1");

  void selectApi(String api) {
    state = api;
  }
}

/// Provides the selected API for the [CatalogueContent] widget. 
/// * "0,1" is the default value, which is both JavaScript and Python APIs.
/// * "0" is JavaScript API.
/// * "1" is Python API.
final catalogueSelectedApiProvider =
    StateNotifierProvider<CatalogueSelectedApiNotifier, String>((ref) {
  return CatalogueSelectedApiNotifier();
});
