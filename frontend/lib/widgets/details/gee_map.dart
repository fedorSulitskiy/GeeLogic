import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/loading_star.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {super.key, required this.code, required this.api, this.height = 300.0, this.width = 700.0});

  final String code;
  final double height;
  final double width;
  final int api;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // Initialise the controller for the WebView widget
  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  );

  /// Function to load the HTML code of the map widget from python api.
  Future<void> loadHTMLString(String uri, String codeString) async {
    Map<String, String> body = {
      'code': codeString,
    };

    String htmlString;
    http.Response response = await http.post(Uri.parse(uri), body: body);
    htmlString = response.body;
    return _controller.loadHtmlString(htmlString);
  }

  @override
  Widget build(BuildContext context) {
    final String apiType;

    if (widget.api == 1) {
      apiType = 'python';
    } else {
      apiType = 'js';
    }
    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height + 20,
        child: FutureBuilder(
          future: loadHTMLString(
              'http://127.0.0.1:3001/python_api/get_map_widget/$apiType?height=${widget.height.toString()}',
              widget.code),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return PlatformWebViewWidget(
                PlatformWebViewWidgetCreationParams(controller: _controller),
              ).build(context);
            }
            return const Center(child: LoadingStar(size: 50.0));
          },
        ),
      ),
    );
  }
}
