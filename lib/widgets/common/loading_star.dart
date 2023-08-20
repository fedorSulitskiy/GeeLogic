import 'dart:math';

import 'package:flutter/material.dart';

/// Widget used for loading animation. A pulsating star that also changes colour.
/// Colour changing code was reused multiple times in other widgets such as
/// the [SignInButton] or [AddAlgorithmButton].
class LoadingStar extends StatefulWidget {
  const LoadingStar({super.key, this.size = 30.0});

  final double size;

  @override
  State<LoadingStar> createState() => _LoadingStarState();
}

class _LoadingStarState extends State<LoadingStar>
    with SingleTickerProviderStateMixin {
  /// The list of colours to be used for the gradient.
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];

  /// The list of alignments to be used for the gradient.
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];

  /// The index of the current colour and alignment.
  int index = 0;

  /// The initial bottom colour of the gradient.
  Color bottomColor = Colors.red;

  /// The initial top colour of the gradient.
  Color topColor = Colors.yellow;

  /// The initial alignment of the gradient.
  Alignment begin = Alignment.bottomLeft;

  /// The initial alignment of the gradient.
  Alignment end = Alignment.topRight;

  /// Boolean that controls the star's expansion and contraction.
  bool isExpanded = true;

  /// The size of the star.
  late double size;

  @override
  void initState() {
    super.initState();

    setState(() {
      // set the initial size
      size = widget.size;
    });

    // This code ensures the star is animated on the first build, and keeps it
    // animating afterwards.
    Future.delayed(const Duration(milliseconds: 2), () {
      if (mounted) {
        setState(() {
          bottomColor = Colors.blue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      // Dirty way to keep the animated container from
      // affecting the neighbouring widgets by wrapping it in a column.
      child: Column(
        children: [
          ClipPath(
            clipper: _StarClipper(),
            child: AnimatedContainer(
              height: size,
              width: size,
              // padding: EdgeInsets.all(30.0 - size),
              duration: const Duration(seconds: 1),
              curve: Curves.fastEaseInToSlowEaseOut,
              onEnd: () {
                setState(() {
                  index = index + 1;
                  // animate the color
                  bottomColor = colorList[index % colorList.length];
                  topColor = colorList[(index + 1) % colorList.length];

                  // animate the alignment
                  begin = alignmentList[index % alignmentList.length];
                  end = alignmentList[(index + 2) % alignmentList.length];

                  // animate the size
                  isExpanded = !isExpanded;
                  isExpanded ? size = widget.size * 0.8 : size = widget.size;
                });
              },
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [bottomColor, topColor],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom clipper used to create the star shape.
class _StarClipper extends CustomClipper<Path> {
  /// The number of points of the star
  final int points = 4;

  // Degrees to radians conversion
  double _degreeToRadian(double deg) => deg * (pi / 180.0);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double max = 2 * pi;

    double width = size.width;
    double halfWidth = width / 2;

    double wingRadius = halfWidth;
    double radius = halfWidth / 2;

    double degreesPerStep = _degreeToRadian(360 / points);
    double halfDegreesPerStep = degreesPerStep / 2;

    path.moveTo(width, halfWidth);

    for (double step = 0; step < max; step += degreesPerStep) {
      path.lineTo(
        halfWidth + wingRadius * cos(step),
        halfWidth + wingRadius * sin(step),
      );
      path.lineTo(
        halfWidth + radius * cos(step + halfDegreesPerStep),
        halfWidth + radius * sin(step + halfDegreesPerStep),
      );
    }

    path.close();
    return path;
  }

  // If the new instance represents different information than the old instance,
  // this method will return true, otherwise it should return false.
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    _StarClipper starClipper = oldClipper as _StarClipper;
    return points != starClipper.points;
  }
}
