// import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

const String kLocalExamplePage = '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
</head>
<body>

<h1>Local demo page</h1>
<p>
  This is an example page used to demonstrate how to load a local file or HTML
  string using the <a href="https://pub.dev/packages/webview_flutter">Flutter
  webview</a> plugin.
</p>

</body>
</html>
''';

class WebScreen2 extends StatefulWidget {
  const WebScreen2({super.key});

  @override
  State<WebScreen2> createState() => _WebScreen2State();
}

class _WebScreen2State extends State<WebScreen2> {
  String? htmlContent;

  @override
  void initState() {
    super.initState();
    // Load the HTML code for my_map.html
    loadHTMLString().then((value) {
      setState(() {
        htmlContent = value;
      });
    });
  }

  // Function to load the HTML code
  Future<String> loadHTMLString() async {
    late final String htmlString;
    try {
      htmlString = await rootBundle.loadString('assets/my_map.html');
    } catch (e) {
      print('Error loading HTML file: $e');
    }
    return htmlString;
  }

  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  )..loadRequest(
      LoadRequestParams(
        uri: Uri.parse('https://flutter.dev'),
      ),
    );

  Future<void> _onLoadHTML() {
    return _controller.loadHtmlString(htmlContent!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yulu is a cute girl'),
        actions: <Widget>[
          // _SampleMenu(_controller),
          IconButton(onPressed: _onLoadHTML, icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 1000,
          height: 500,
          child: PlatformWebViewWidget(
            PlatformWebViewWidgetCreationParams(controller: _controller),
          ).build(context),
        ),
      ),
    );
  }
}

// enum _MenuOptions {
//   doPostRequest,
// }

// class _SampleMenu extends StatelessWidget {
//   const _SampleMenu(this.controller);

//   final PlatformWebViewController controller;

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<_MenuOptions>(
//       onSelected: (_MenuOptions value) {
//         switch (value) {
//           case _MenuOptions.doPostRequest:
//             _onDoPostRequest(controller);
//             break;
//         }
//       },
//       itemBuilder: (BuildContext context) => <PopupMenuItem<_MenuOptions>>[
//         const PopupMenuItem<_MenuOptions>(
//           value: _MenuOptions.doPostRequest,
//           child: Text('Post Request'),
//         ),
//       ],
//     );
//   }

//   Future<void> _onDoPostRequest(PlatformWebViewController controller) async {
//     final LoadRequestParams params = LoadRequestParams(
//       uri: Uri.parse('https://httpbin.org/post'),
//       method: LoadRequestMethod.post,
//       headers: const <String, String>{
//         'foo': 'bar',
//         'Content-Type': 'text/plain'
//       },
//       body: Uint8List.fromList('Test Body'.codeUnits),
//     );
//     await controller.loadRequest(params);
//   }
// }
