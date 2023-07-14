import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:frontend/providers/algo_info_provider.dart';
import 'package:frontend/widgets/algo_details/description_text.dart';
import 'package:frontend/widgets/algo_details/sub_title_text.dart';
import 'package:frontend/widgets/algo_details/title_element.dart';
import 'package:frontend/widgets/algo_details/code_display.dart';
import 'package:frontend/widgets/placeholders/placeholder_map.dart';
// import 'package:frontend/widgets/gee_map_widget.dart';
// import 'package:frontend/widgets/placeholders/data/placeholder_data.dart';

class DetailsCard extends ConsumerWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final algoId = ref.watch(algoIdProvider);
    final data = ref.watch(algoInfoProvider).singleWhere(
          (element) => element.id == algoId,
        );

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
                TitleElement(title: data.title, data: data),
                // const MapWidget(),
                const PlaceholderMap(),
                const CodeDisplayWidget(),
                const SubTitleText(title: 'Description'),
                DescriptionText(text: data.description),
                const SubTitleText(title: 'Tags'),
                const SubTitleText(title: 'Comments'),
              ],
            ),
          ),
        ],
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
