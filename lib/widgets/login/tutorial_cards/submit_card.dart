import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/login/tutorial_card.dart';

/// Third tutorial card to display.
class SubmissionCard extends StatelessWidget {
  const SubmissionCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Share your research.',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Text(
          'If you have something to share, we would love to hear from you! Collaborate with other researchers and developers to build impactful solutions.',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 19.0),
        ),
        const SizedBox(height: 13.0),
        _AddAlgorithmButton(),
        const Divider(),
        const _VerifyButton(
          comment: 'Click to verify your code!',
        ),
        const _VerifyButton(
            comment: 'It will turn green if successfully validated...',
            isValid: true),
        const _VerifyButton(comment: '...or red if not.', isValid: false),
        const Divider(),
        const _SubmitButton(comment: 'Wait until "submit" turns colourful, and submit!'),
      ],
    );
  }
}

const double borderRadius = 18.0;
const List<double> buttonDimensions = [45, 80.0];

/// Replica of [AddAlgorithmButton] with corresponding bullet-point.
class _AddAlgorithmButton extends StatefulWidget {
  @override
  State<_AddAlgorithmButton> createState() => __AddAlgorithmButtonState();
}

class __AddAlgorithmButtonState extends State<_AddAlgorithmButton> {
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
        const BulletPoint(
          text: 'Press the add button to share your work',
          width: 230,
        ),
      ],
    );
  }
}

/// Replica of [VerifyButton] from [InputScreen] with corresponding bullet-point.
class _VerifyButton extends StatefulWidget {
  const _VerifyButton({this.isValid, required this.comment});

  final bool? isValid;
  final String comment;

  @override
  State<_VerifyButton> createState() => __VerifyButtonState();
}

class __VerifyButtonState extends State<_VerifyButton> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
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
        ),
        BulletPoint(
          text: widget.comment,
          width: 220,
        ),
      ],
    );
  }
}

/// /// Replica of [SubmitButton] from [InputScreen] with corresponding bullet-point.
class _SubmitButton extends StatefulWidget {
  const _SubmitButton({required this.comment});

  final String comment;

  @override
  State<_SubmitButton> createState() => __SubmitButtonState();
}

class __SubmitButtonState extends State<_SubmitButton> {
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
      mainAxisAlignment: MainAxisAlignment.start,
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
        BulletPoint(
          text: widget.comment,
          width: 230,
        ),
      ],
    );
  }
}
