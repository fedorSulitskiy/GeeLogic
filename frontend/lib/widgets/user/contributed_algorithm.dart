import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/algo_info_provider.dart';
import 'package:frontend/screens/details_screen.dart';

import 'package:frontend/widgets/common/tag_bubble_plain.dart';
import 'package:frontend/widgets/user/user_content.dart';

class ContributedAlgorithm extends ConsumerWidget {
  const ContributedAlgorithm({
    super.key,
    required this.title,
    required this.imageURL,
    required this.tags,
    required this.algoId,
  });

  final String title;
  final String imageURL;
  final List<dynamic> tags;
  final int algoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        // Establish a context before async gap
        final navContext = Navigator.of(context);
        // Load data for the selected algorithm
        final data = await ref.watch(
          singleAlgorithmProvider(
            algoId.toString(),
          ),
        );
        // Navigate to the details screen of selected algorithm
        navContext.push(
          MaterialPageRoute(
            builder: (ctx) => DetailsScreen(data: data['results'][0]),
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
                      imageURL,
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
                      Text(
                        title,
                        style: Theme.of(context).textTheme.displaySmall,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: tags
                              .map((e) => TagBubblePlain(
                                    id: e['tag_id'],
                                    title: e['tag_name'],
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
