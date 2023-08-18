import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/helpers/custom_icons/custom_icons_icons.dart';
import 'package:frontend/helpers/uri_parser/uri_parse.dart';
import 'package:frontend/models/algo_data.dart';
import 'package:frontend/providers/algo_info_provider.dart';
import 'package:frontend/providers/algo_selection_provider.dart';

final _firebase = FirebaseAuth.instance;

/// The card that displays the algorithm's information in brief. Used to
/// allow for quick navigation of multiple algorithms.
class AlgoCard extends ConsumerStatefulWidget {
  const AlgoCard({
    super.key,
    required this.data,
    required this.index,
    required this.isSelected,
  });

  final AlgoData data;
  final int index;
  final bool isSelected;

  @override
  ConsumerState<AlgoCard> createState() => _AlgoCardState();
}

class _AlgoCardState extends ConsumerState<AlgoCard> {
  static double borderRadius = 16.0;
  static double cardHeight = 216.0;
  static double cardWidth = 360.0;

  /// Colour of the border around the card
  static Color cardColour = Colors.blue;

  /// Colour of the absolute value of the net vote if positive (more up votes than down votes)
  static Color positiveNet = const Color.fromARGB(255, 66, 133, 244);

  /// Colour of the absolute value of the net vote if negative (more down votes than up votes)
  static Color negativeNet = const Color.fromARGB(255, 234, 67, 53);

  @override
  Widget build(BuildContext context) {
    // Use [dataManager] [ChangeNotifierProvider] to instantly update the status of
    // the isBookmarked attribute of any algorithm, without having to wait for the
    // [FutureBuilder] to rebuild the widget.
    final dataManager = ref.watch(dataManagerProvider);
    return InkWell(
      onTap: () {
        // Notifies the [selectedAlgoIndexProvider] that this card has been selected,
        // by passing its index to the provider's notifier. This index will be used in
        // CatalogueScreen to show selection aura around the selected card, and in the
        // DetailsCard on the same screen to show the details of the selected algorithm.
        ref.read(selectedAlgoIndexProvider.notifier).selectCard(widget.index);
      },
      splashColor: cardColour,
      child: Card(
        elevation: 4,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // background picture and coloured border and white text highlight
            Stack(
              alignment: Alignment.center,
              children: [
                // background image
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      widget.data.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // selection aura
                if (widget.isSelected)
                  Container(
                    width: cardWidth,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        radius: 2.0,
                        colors: [
                          cardColour.withOpacity(0.1),
                          cardColour.withOpacity(1.0),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                // white shade to highlight text
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(0.00, -1.00),
                      end: const Alignment(0, 1),
                      colors: [Colors.white.withOpacity(0), Colors.white],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                    ),
                  ),
                ),
                // border
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: cardColour,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ],
            ),
            // Information at the bottom
            SizedBox(
              width: cardWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Title and Date
                  SizedBox(
                    width: 224,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 30),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(widget.data.formattedDate),
                        ],
                      ),
                    ),
                  ),
                  // Side buttons; votes and bookmark
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _SideButton(
                          icon: widget.data.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 24.0,
                          onPressed: () async {
                            // Update data in the database
                            if (widget.data.isBookmarked) {
                              // Delete bookmark if it exists
                              final headers = {
                                'Content-Type': 'application/json'
                              };
                              final body = json.encode({
                                "algo_id": widget.data.id,
                                "user_id": _firebase.currentUser!.uid,
                              });
                              await http.delete(
                                nodeUri('remove_bookmark'),
                                headers: headers,
                                body: body,
                              );
                            } else {
                              // Add bookmark if it doesn't exist
                              final headers = {
                                'Content-Type': 'application/json'
                              };
                              final body = json.encode({
                                "algo_id": widget.data.id,
                                "user_id": _firebase.currentUser!.uid,
                              });
                              await http.post(
                                nodeUri('bookmark_algo'),
                                headers: headers,
                                body: body,
                              );
                            }

                            // Update data locally
                            final updatedAlgo = AlgoData(
                              id: widget.data.id,
                              title: widget.data.title,
                              upVotes: widget.data.upVotes,
                              downVotes: widget.data.downVotes,
                              datePosted: widget.data.datePosted,
                              image: widget.data.image,
                              description: widget.data.description,
                              isBookmarked: !widget.data.isBookmarked,
                              api: widget.data.api,
                              code: widget.data.code,
                              userCreator: widget.data.userCreator,
                              tags: widget.data.tags,
                            );
                            // Notifies the [dataManagerProvider] that this algorithm has been bookmarked,
                            // by passing its index to the provider's notifier. This index will be used in
                            // CatalogueScreen to show bookmarked icon on the card, and in the
                            // DetailsCard on the same screen to show the details of the bookmarked algorithm.
                            dataManager.updateSingleData(
                                widget.data.id, updatedAlgo);
                          },
                        ),
                        _SideButton(
                          icon: Icons.arrow_drop_up,
                          size: 35.0,
                          onPressed: () {},
                        ),
                        Text(
                          widget.data.netVotes.abs().toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: widget.data.netVotes.isNegative
                                      ? negativeNet
                                      : positiveNet),
                        ),
                        _SideButton(
                          icon: Icons.arrow_drop_down,
                          size: 35.0,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Icon representation of what API is used by the algorithm (python or JS)
            Positioned(
              right: 10.0,
              top: 10.0,
              child: widget.data.api == 1
                  ? const Icon(
                      CustomIcons.python,
                      color: Color.fromARGB(255, 48, 105, 152),
                    )
                  : const Icon(
                      CustomIcons.jsSquare,
                      color: Color.fromARGB(255, 240, 219, 79),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Side buttons for the card, including bookmark, upvote, downvote
class _SideButton extends StatefulWidget {
  const _SideButton({
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  final double size;
  final IconData icon;
  final void Function() onPressed;

  @override
  State<_SideButton> createState() => _SideButtonState();
}

class _SideButtonState extends State<_SideButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        icon: Icon(widget.icon, size: widget.size),
        onPressed: widget.onPressed,
      ),
    );
  }
}
