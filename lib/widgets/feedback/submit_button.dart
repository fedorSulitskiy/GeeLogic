import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double borderRadius = 15.0;
const List<double> buttonDimensions = [32.0, 90.0];

/// Submits the feedback of the user.
class SubmitButton extends ConsumerStatefulWidget {
  const SubmitButton({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  ConsumerState<SubmitButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends ConsumerState<SubmitButton> {
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
    return Center(
      child: AnimatedContainer(
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: Colors.white.withOpacity(0.5),
            onTap: widget.onPressed,
            child: Container(
              height: buttonDimensions[0],
              width: buttonDimensions[1],
              alignment: Alignment.center,
              child: Text(
                'submit',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
