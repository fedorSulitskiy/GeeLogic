import 'package:flutter/material.dart';

const double borderRadius = 30.0;
const List<double> buttonDimensions = [30.0, 100.0];

/// /// Replica of [SubmitButton] from [InputScreen] with corresponding bullet-point.
class MockSubmit extends StatefulWidget {
  const MockSubmit({super.key});

  @override
  State<MockSubmit> createState() => _MockSubmitState();
}

class _MockSubmitState extends State<MockSubmit> {
  /// List of colors to be used for the background of the button when
  /// submission is not available.
  List<Color> colorList = [
    Colors.grey.shade900,
    Colors.blueGrey.shade900,
    Colors.grey.shade800,
    Colors.blueGrey.shade800
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.grey.shade900;
  Color topColor = Colors.blueGrey.shade800;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  bool _isUploading = false;

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
          alignment: Alignment.center,
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
                borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
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
                      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                    ),
                  ),
                ),
                onPressed: () {
                  // Complete the task
                  setState(() {
                    _isUploading = !_isUploading;
                  });

                  if (_isUploading) {
                    /// Change colour of the button if submission is available.
                    setState(() {
                      colorList = [
                        Colors.red,
                        Colors.blue,
                        Colors.green,
                        Colors.yellow,
                      ];
                      bottomColor = Colors.red;
                      topColor = Colors.yellow;
                    });
                  } else {
                    setState(() {
                      colorList = [
                        Colors.grey.shade900,
                        Colors.blueGrey.shade900,
                        Colors.grey.shade800,
                        Colors.blueGrey.shade800
                      ];
                      bottomColor = Colors.grey.shade900;
                      topColor = Colors.blueGrey.shade800;
                    });
                  }
                },
                child: _isUploading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'submit',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Colors.white,
                              fontSize: 16.0,
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
