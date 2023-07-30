import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/loading_star.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key, this.height = 300.0, this.width = 700.0});

  final double height;
  final double width;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  bool _isLoading = true;

  // Initialise the controller for the WebView widget
  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  );

  @override
  void initState() {
    super.initState();
    // Load the HTML code for my_map.html
    loadHTMLString(
            'http://127.0.0.1:5000/get_map_widget?height=${widget.height.toString()}')
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Function to load the HTML code
  Future<void> loadHTMLString(String uri) async {
    String htmlString;
    http.Response response = await http.get(Uri.parse(uri));
    htmlString = response.body;
    return _controller.loadHtmlString(htmlString);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height + 20,
        child: _isLoading
            ? const Center(
                child: LoadingStar(size: 50.0),
              )
            : PlatformWebViewWidget(
                PlatformWebViewWidgetCreationParams(controller: _controller),
              ).build(context),
      ),
    );
  }
}
