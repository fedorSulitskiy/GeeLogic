import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/loading_star.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

const pycode =
    "# Create a map using GEE API and geemap\nMap = geemap.Map(center=[21.79, 70.87], zoom=3, zoom_ctrl=True, data_ctrl=False, fullscreen_ctrl=False, search_ctrl=False, draw_ctrl=False, scale_ctrl=False, measure_ctrl=False, toolbar_ctrl=False, layer_ctrl=False, attribution_ctrl=False)\nimage = geemap.ee.Image('USGS/SRTMGL1_003')\nvis_params = {'min': 0, 'max': 6000, 'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5']}\nMap.addLayer(image, vis_params, 'SRTM')";

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
            'http://127.0.0.1:3001/get_map_widget?height=${widget.height.toString()}',
            pycode)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Function to load the HTML code
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
    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height + 20,
        child: _isLoading
            ? const Center(child: LoadingStar(size: 50.0))
            : PlatformWebViewWidget(
                PlatformWebViewWidgetCreationParams(controller: _controller),
              ).build(context),
      ),
    );
  }
}
