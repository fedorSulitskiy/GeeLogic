import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/screens/details_screen.dart';
import 'package:frontend/widgets/common/tag_bubble_plain.dart';
import 'package:frontend/widgets/user/bookmark_button.dart';
import 'package:frontend/widgets/user/edit_and_delete_buttons.dart';
import 'package:frontend/app_theme.dart';
import 'package:frontend/custom_page_route.dart';

/// Displays the widget seen inside the [UserScreen], holding information
/// about one of the algorithms either contributed or bookmarked by the user.
class UsersAlgorithm extends ConsumerWidget {
  const UsersAlgorithm({
    super.key,
    required this.data,
    required this.isContribution,
    this.removeFunction,
  });

  final AlgoData data;
  final bool isContribution;
  final Function(int)? removeFunction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Responsive design
    var screenSize = MediaQuery.of(context).size;

    var width = screenSize.width * 0.6;

    if (width < 500) {
      width = screenSize.width * 0.9;
    }

    return InkWell(
      onTap: () async {
        // Establish a context before async gap
        final navContext = Navigator.of(context);

        // Navigate to the details screen of selected algorithm
        navContext.push(
          CustomPageRoute(
            builder: (ctx) => DetailsScreen(data: data),
          ),
        );
      },
      child: Container(
        height: 90,
        width: width,
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: GeeLogicColourScheme.borderGrey,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            // Fading Image Tumbnail
            Positioned(
              top: 0,
              left: 0,
              child: Container(
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
            ),
            Positioned(
              right: 0,
              child: SizedBox(
                height: 90,
                width: width > 740 ? width - 300.0 : 440,
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
                            ? EditAndDeleteButtons(
                                data: data,
                                removeFunction: removeFunction!,
                              )
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
