import 'package:flutter/material.dart';
import 'package:frontend/screens/input_screen.dart';

const double borderRadius = 18.0;
const List<double> buttonDimensions = [45.0, 80.0];

/// Button at the top right corner that directs user to the input screen.
class AddAlgorithmButton extends StatefulWidget {
  const AddAlgorithmButton({super.key});

  @override
  State<AddAlgorithmButton> createState() => _AddAlgorithmButtonState();
}

class _AddAlgorithmButtonState extends State<AddAlgorithmButton> {
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
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            right: 16.0,
          ),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const InputScreen(),
                      ),
                    );
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
