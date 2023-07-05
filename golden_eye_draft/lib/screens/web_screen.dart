import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
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

  @override
  Widget build(BuildContext context) {
    print(htmlContent);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widget from HTML'),
      ),
      body: Center(
        // Loading content handling to avoid any problems late variables
        child: htmlContent != null
            ? SizedBox(
                height: 200,
                width: 200,
                child: HtmlWidget(htmlContent!),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
