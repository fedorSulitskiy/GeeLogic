import 'dart:js_interop';

import 'package:flutter/material.dart';

const double borderRadius = 15.0;
const List<double> buttonDimensions = [32.0, 80.0];

/// Replica of [VerifyButton] from [InputScreen] with corresponding bullet-point.
class MockVerifyButton extends StatefulWidget {
  const MockVerifyButton({super.key, this.isValid});

  final bool? isValid;

  @override
  State<MockVerifyButton> createState() => _MockVerifyButtonState();
}

class _MockVerifyButtonState extends State<MockVerifyButton> {
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.red;
  Color topColor = Colors.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  /// Determines if the function is waiting for response from the backend.
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (!widget.isValid.isNull) {
      if (widget.isValid!) {
        setState(() {
          colorList = const [
            Color.fromARGB(255, 59, 183, 143),
            Color.fromARGB(255, 11, 171, 100),
          ];
        });
      } else {
        setState(() {
          colorList = const [
            Color.fromARGB(255, 217, 131, 36),
            Color.fromARGB(255, 164, 6, 6),
          ];
        });
      }
    }

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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedContainer(
              height: buttonDimensions[0],
              width: buttonDimensions[1],
              duration: const Duration(seconds: 2),
              curve: Curves.linear,
              onEnd: () {
                setState(() {
                  index = index + 1;
                  // animate the color
                  bottomColor = colorList[index % colorList.length];
                  topColor = colorList[(index + 1) % colorList.length];

                  // animate the alignment
                  begin = alignmentList[index % alignmentList.length];
                  end = alignmentList[(index + 2) % alignmentList.length];
                });
              },
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.circular(borderRadius)),
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [bottomColor, topColor],
                ),
              ),
            ),
            SizedBox(
              height: buttonDimensions[0],
              width: buttonDimensions[1],
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius)),
                    ),
                  ),
                ),
                onPressed: () {
                  if (widget.isValid.isNull) {
                    // Initialise loading animation.
                    setState(() {
                      _isLoading = !_isLoading;
                    });
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: _isLoading
                      ? const SizedBox(
                          height: 25.0,
                          width: 25.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : widget.isValid.isNull
                          ? Text(
                              'Verify',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: Colors.white, fontSize: 20.0),
                            )
                          : widget.isValid!
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 25.0,
                                )
                              : const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
