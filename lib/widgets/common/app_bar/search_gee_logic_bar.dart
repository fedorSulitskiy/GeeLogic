import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/screens/details_screen.dart';
import 'package:frontend/helpers/uri_parser/uri_parse.dart';
import 'package:frontend/providers/algo_info_provider.dart';
import 'package:frontend/app_theme.dart';

/// The top search bar that allow for searching of algorithms.
class SearchGeeLogicBar extends ConsumerStatefulWidget {
  const SearchGeeLogicBar({super.key});

  @override
  ConsumerState<SearchGeeLogicBar> createState() => _SearchGeeLogicBarState();
}

class _SearchGeeLogicBarState extends ConsumerState<SearchGeeLogicBar> {
  OverlayEntry? _overlayEntry;
  List<dynamic> apiResponse = [];

  /// Fetches data from the API, calling `search` endpoint of the Node API
  Future<List<dynamic>> fetchDataFromApi({required String query}) async {
    try {
      final url = nodeUri('search');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({'keyword': query});
      final response = await http.post(url, headers: headers, body: body);
      return json.decode(response.body);
    } catch (e) {
      return [];
    }
  }

  /// Shows the overlay of the search results.
  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: offset.dy + size.height,
          left: offset.dx,
          width: size.width,
          child: Listener(
            onPointerDown: (_) {},
            child: Material(
              elevation: 4.0,
              child: Container(
                height: apiResponse.length * 30.0 +
                    (apiResponse.isEmpty ? 0 : 15.0),
                color: GeeLogicColourScheme.backgroundColour,
                // TODO: adjust for responsive design
                constraints: const BoxConstraints(maxHeight: 900.0),
                child: ListView.builder(
                  itemExtent: 30.0,
                  itemCount: apiResponse.length,
                  itemBuilder: (context, index) {
                    String tagName = apiResponse[index]['title'];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: TextButton(
                        child: Text(tagName),
                        onPressed: () async {
                          // Remove the overlay to prevent errors related to it
                          _removeOverlay();
                          // Establish a context before async gap
                          final navContext = Navigator.of(context);
                          // Load data for the selected algorithm
                          final data = await ref.watch(
                            singleAlgorithmProvider(
                              apiResponse[index]['algo_id'].toString(),
                            ),
                          );
                          // Navigate to the details screen of selected algorithm
                          navContext.push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  DetailsScreen(data: data['results'][0]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => overlay.insert(_overlayEntry!),
    );
  }

  /// Removes the overlay of the search results.
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8.0,
        top: 16.0,
        bottom: 16.0,
        right: 54.0,
      ),
      color: GeeLogicColourScheme.backgroundColour,
      child: TextField(
        style:
            Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18.0),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'search geeLogic',
          hintStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 18.0),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 0.0,
          ),
          isDense: true,
          icon: const Icon(
            Icons.search,
            size: 30,
          ),
        ),
        maxLines: 1,
        onChanged: (value) async {
          final response = await fetchDataFromApi(query: value);
          setState(() {
            if (value.isEmpty) {
              // Remove overlay if textfield is empty
              _removeOverlay();
            } else {
              // Show overlay if textfield is not empty
              // NOTE: It's imperative to show this only once, since the overlay
              // breaks if more than one is ever shown at once
              if (_overlayEntry.isNull) {
                _showOverlay();
              }
            }
            if (!_overlayEntry.isNull) {
              // Update the state of the overlay
              apiResponse = response;
              _overlayEntry!.markNeedsBuild();
            }
          });
        },
        onTap: () {
          if (_overlayEntry.isNull) {
            _showOverlay();
          } else {
            _removeOverlay();
          }
        },
      ),
    );
  }
}
