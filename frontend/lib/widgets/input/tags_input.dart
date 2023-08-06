import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/tags_provider.dart';
import 'package:frontend/widgets/input/tag_bubble.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/widgets/_archive/login_details.dart';

// final List<TagBubble> tagsList = [
//   const TagBubble(title: 'wrestle'),
//   const TagBubble(title: 'monk'),
//   const TagBubble(title: 'survivor'),
//   const TagBubble(title: 'neck'),
//   const TagBubble(title: 'shadow'),
//   const TagBubble(title: 'glide'),
//   const TagBubble(title: 'state'),
//   const TagBubble(title: 'efflux'),
//   const TagBubble(title: 'tax'),
// ];

class TagsInput extends ConsumerStatefulWidget {
  const TagsInput({super.key, this.width = 900.0});

  final double width;

  @override
  ConsumerState<TagsInput> createState() => _TagsInputState();
}

class _TagsInputState extends ConsumerState<TagsInput> {
  List<dynamic> apiResponse = [];
  bool _hover = false;

  Future<List<dynamic>> fetchDataFromApi({required String query}) async {
    try {
      final url = Uri.parse('http://localhost:3000/node_api/search_tags');
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
    final List<dynamic> selectedTags = ref.watch(selectedTagsProvider);
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
        width: 884.0,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: _hover
                ? Colors.black
                : const Color.fromARGB(255, 123, 126, 134),
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
              cursorColor: googleBlue,
              maxLines: 1,
              onChanged: (value) async {
                List<dynamic> response = await fetchDataFromApi(query: value);
                List<dynamic> itemsNotInSelectedTags = response.where((item) {
                  final itemId = item['tag_id'];
                  return !selectedTags.any((tag) => tag['tag_id'] == itemId);
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
                            selectedTags.add(
                              apiResponse[index],
                            );
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
                    title: tag['tag_name'],
                    id: tag['tag_id'],
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
