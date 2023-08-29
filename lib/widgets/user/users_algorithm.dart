import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/screens/details_screen.dart';
import 'package:frontend/widgets/common/tag_bubble_plain.dart';
import 'package:frontend/widgets/user/bookmark_button.dart';
import 'package:frontend/widgets/user/edit_and_delete_buttons.dart';
import 'package:frontend/widgets/user/user_content.dart';

/// Displays the widget seen inside the [UserScreen], holding information
/// about one of the algorithms either contributed or bookmarked by the user.
class UsersAlgorithm extends ConsumerWidget {
  const UsersAlgorithm({
    super.key,
    required this.data,
    required this.isContribution,
  });

  final AlgoData data;
  final bool isContribution;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        // Establish a context before async gap
        final navContext = Navigator.of(context);
        
        // Navigate to the details screen of selected algorithm
        navContext.push(
          MaterialPageRoute(
            builder: (ctx) => DetailsScreen(data: data),
          ),
        );
      },
      child: Container(
        height: 90,
        width: double.infinity,
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            Row(
              children: [
                // Fading Image Tumbnail
                Container(
                  width: 300.0,
                  height: 90,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.zero,
                    ),
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.transparent, Colors.white],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        tileMode: TileMode.clamp,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                      data.image,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                // Text and Tags
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              data.title,
                              style: Theme.of(context).textTheme.displaySmall,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          isContribution
                              ? EditAndDeleteButtons(algoId: data.id)
                              : BookmarkButton(algoId: data.id),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: data.tags
                              .map((e) => TagBubblePlain(
                                    id: e.tagId,
                                    title: e.tagName,
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
