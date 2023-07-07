import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  bool _isLoading = true;

  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  );

  @override
  void initState() {
    super.initState();
    // Load the HTML code for my_map.html
    loadHTMLString('http://127.0.0.1:5000/get_map_widget').then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Function to load the HTML code
  Future<void> loadHTMLString(String uri) async {
    final String htmlString;
    http.Response response = await http.get(Uri.parse(uri));
    htmlString = response.body;
    return _controller.loadHtmlString(htmlString);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 700,
        height: 320,
        child: _isLoading
            ? const CircularProgressIndicator()
            : PlatformWebViewWidget(
                PlatformWebViewWidgetCreationParams(controller: _controller),
              ).build(context),
      ),
    );
  }
}
