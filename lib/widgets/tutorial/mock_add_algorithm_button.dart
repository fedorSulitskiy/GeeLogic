import 'package:flutter/material.dart';

const double borderRadius = 18.0;
const List<double> buttonDimensions = [45, 80.0];

/// Replica of [AddAlgorithmButton] with corresponding bullet-point.
class MockAlgorithmButton extends StatefulWidget {
  const MockAlgorithmButton({super.key});

  @override
  State<MockAlgorithmButton> createState() => _MockAlgorithmButtonState();
}

class _MockAlgorithmButtonState extends State<MockAlgorithmButton> {
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

  bool isTapped = false;

  @override
  void initState() {
    super.initState();

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
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
                  setState(() {
                    isTapped = !isTapped;
                  });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: isTapped
                      ? const SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 7.0,
                          ),
                        )
                      : const Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}