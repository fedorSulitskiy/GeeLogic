import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/helpers/uri_parser/uri_parse.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/providers/input_tags_provider.dart';
import 'package:frontend/widgets/common/tag_bubble.dart';

/// Widget to display the tags input field.
class TagsInput extends ConsumerStatefulWidget {
  const TagsInput({super.key, this.width = 900.0});

  final double width;

  @override
  ConsumerState<TagsInput> createState() => _TagsInputState();
}

class _TagsInputState extends ConsumerState<TagsInput> {
  List<dynamic> apiResponse = [];
  bool _hover = false;

  /// Function used to fetch the tags that satisfy the immediate input.
  Future<List<dynamic>> fetchDataFromApi({required String query}) async {
    try {
      final url = nodeUri('search_tags');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({'keyword': query});
      final response = await http.post(url, headers: headers, body: body);
      return json.decode(response.body);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Tag> selectedTags = ref.watch(selectedTagsProvider);
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _hover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _hover = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: widget.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: _hover
                ? Colors.black
                : GeeLogicColourScheme.borderGrey,
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            TextField(
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: 'Search for tags!',
                hintStyle: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 18.0),
                border: InputBorder.none,
                constraints: BoxConstraints(
                  maxWidth: widget.width,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 8.0,
                ),
              ),
              cursorColor: GeeLogicColourScheme.blue,
              maxLines: 1,
              onChanged: (value) async {
                /// Fetch the tags that satisfy the immediate input.
                List<dynamic> response = await fetchDataFromApi(query: value);
                List<dynamic> itemsNotInSelectedTags = response.where((item) {
                  final itemId = item['tag_id'];
                  return !selectedTags.any((tag) => tag.tagId == itemId);
                }).toList();
                setState(() {
                  apiResponse = itemsNotInSelectedTags;
                });
              },
            ),
            SizedBox(
              height: apiResponse.isEmpty ? 0.0 : 100.0,
              child: ListView.builder(
                itemExtent: 30.0,
                itemCount: apiResponse.length,
                itemBuilder: (context, index) {
                  String tagName = apiResponse[index]['tag_name'];
                  return Container(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      title: TextButton(
                        child: Text(tagName),
                        onPressed: () {
                          setState(() {
                            // Add the tag to the selected tags list.
                            selectedTags.add(
                              Tag.fromJson(apiResponse[index]),
                            );

                            // Remvoe the tag from the api response list.
                            apiResponse.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 884.0,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8.0,
                runSpacing: 8.0,
                children: selectedTags.map((tag) {
                  return TagBubble(
                    title: tag.tagName,
                    id: tag.tagId,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
