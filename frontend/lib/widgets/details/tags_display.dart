import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/tag_bubble_plain.dart';

class TagsDisplay extends StatelessWidget {
  const TagsDisplay({super.key, required this.tags});

  final List<dynamic> tags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 4.0,
        runSpacing: 4.0,
        children: tags.map((tag) {
          return TagBubblePlain(
            title: tag['tag_name'],
            id: tag['tag_id'],
          );
        }).toList(),
      ),
    );
  }
}
