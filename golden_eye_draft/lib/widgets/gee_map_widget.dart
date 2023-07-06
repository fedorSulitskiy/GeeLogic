import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    loadHTMLString().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Function to load the HTML code
  Future<void> loadHTMLString() async {
    late final String htmlString;
    try {
      htmlString = await rootBundle.loadString('assets/my_map.html');
    } catch (e) {
      print('Error loading HTML file: $e');
    }
    return _controller.loadHtmlString(htmlString);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 700,
        height: 900,
        child: _isLoading
            ? const CircularProgressIndicator()
            : PlatformWebViewWidget(
                PlatformWebViewWidgetCreationParams(controller: _controller),
              ).build(context),
      ),
    );
  }
}
