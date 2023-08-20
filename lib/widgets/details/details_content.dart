import 'package:flutter/material.dart';

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/widgets/details/code_display.dart';
import 'package:frontend/widgets/details/description_text.dart';
import 'package:frontend/widgets/details/map.dart';
import 'package:frontend/widgets/details/sub_title_text.dart';
import 'package:frontend/widgets/details/tags_display.dart';
import 'package:frontend/widgets/details/user_creator.dart';

/// Widget to display the content of each algorithm.
class DetailsContent extends StatelessWidget {
  const DetailsContent({
    super.key,
    required this.data,
  });

  final AlgoData data;

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
          UserCreatorDisplay(user: data.userCreator, dateCreated: data.formattedDate),
          MapWidget(
            code: data.code,
            api: data.api,
            height: 500,
            width: 900.0,
          ),
          CodeDisplayWidget(code: data.code, apiType: data.api),
          const SubTitleText(title: 'Description'),
          DescriptionText(text: data.description),
          const SubTitleText(title: 'Tags'),
          TagsDisplay(tags: data.tags),
          const SubTitleText(title: 'Comments'),
        ],
      ),
    );
  }
}
