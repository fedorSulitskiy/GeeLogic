import 'package:flutter/material.dart';
import 'package:frontend/models/algo_card.dart';

class AlgoCard extends StatelessWidget {
  const AlgoCard({
    super.key,
    required this.data,
  });

  final AlgoCardData data;

  static double borderRadius = 16.0;
  static double cardHeight = 216.0;
  static double cardWidth = 360.0;
  static Color cardColour = Colors.blue;
  static Color positiveNet = const Color.fromARGB(255, 66, 133, 244);
  static Color negativeNet = const Color.fromARGB(255, 234, 67, 53);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('top kek');
      },
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
                      data.image,
                      fit: BoxFit.cover,
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
                            data.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 30),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(data.formattedDate),
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
                        const _SideButton(
                            icon: Icons.bookmark_border, size: 24.0),
                        const _SideButton(icon: Icons.arrow_drop_up, size: 35.0),
                        Text(
                          data.netVotes.abs().toString(),
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: data.netVotes.isNegative
                                  ? negativeNet
                                  : positiveNet),
                        ),
                        const _SideButton(
                            icon: Icons.arrow_drop_down, size: 35.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideButton extends StatefulWidget {
  const _SideButton({
    // super.key,
    required this.icon,
    required this.size,
  });

  final double size;
  final IconData icon;

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
        onPressed: () {},
      ),
    );
  }
}
