import 'package:flutter/material.dart';

import 'package:frontend/models/algo_card.dart';
import 'package:frontend/widgets/details/code_display.dart';
import 'package:frontend/widgets/details/description_text.dart';
import 'package:frontend/widgets/details/gee_map.dart';
import 'package:frontend/widgets/details/sub_title_text.dart';

class DetailsContent extends StatelessWidget {
  const DetailsContent({
    super.key,
    required this.data,
  });

  final AlgoCardData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Ensures I can scroll beyond the app bar
          const SizedBox(
            height: 25,
          ),
          SubTitleText(title: data.title, fontSize: 50.0),
          const MapWidget(
            height: 500,
            width: 900.0,
          ),
          const CodeDisplayWidget(),
          const SubTitleText(title: 'Description'),
          DescriptionText(text: data.description),
          const SubTitleText(title: 'Tags'),
          const SubTitleText(title: 'Comments'),
        ],
      ),
    );
  }
}
