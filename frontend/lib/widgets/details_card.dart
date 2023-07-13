import 'package:flutter/material.dart';

import 'package:frontend/widgets/placeholders/placeholder_map.dart';
// import 'package:frontend/widgets/placeholders/data/placeholder_data.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    super.key,
    required this.title,
    required this.datePosted,
    required this.description,
    required this.isBookmarked,
  });

  final String title;
  final String datePosted;
  final String description;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Container(
            width: 700,
            // height: 1000,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(title: title),
                const PlaceholderMap(),
                const TitleText(title: 'Desctiption'),
                DescriptionText(text: description),
                const TitleText(title: 'Tags'),
                const TitleText(title: 'Comments'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 30.0),
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

/// USE THEM LATER FOR ADDED FEATURES: ///

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageURI,
  });

  final String imageURI;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          height: 300,
          // width: 400,
          child: Image.network(
            imageURI,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class WebImbedWidget extends StatefulWidget {
  // THIS DOESN'T PROPERLY WORK WITH ANY LINK.
  // REFUSES TO WORK WITH YOUTUBE
  const WebImbedWidget({
    super.key,
    required this.uri,
  });

  final String uri;

  @override
  State<WebImbedWidget> createState() => _WebImbedWidgetState();
}

class _WebImbedWidgetState extends State<WebImbedWidget> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.uri),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          height: 400,
          width: 500,
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }
}
