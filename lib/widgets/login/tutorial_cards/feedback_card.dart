import 'package:flutter/material.dart';

import 'package:frontend/widgets/_archive/login_details.dart';

/// Last tutorial card to display.
class FeedbackCard extends StatefulWidget {
  const FeedbackCard({super.key});

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  final _mockFeedbackKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Let us know what you think',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Text(
          'We always seek to improve the service, so feel free to reach out with your thoughts on how it can be done.',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 19.0),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _mockFeedbackKey,
              child: Column(
                children: [
                  _InputField(title: 'name', onSaved: (value) {}),
                  const SizedBox(height: 5.0),
                  _InputField(
                      title: 'email', isEmail: true, onSaved: (value) {}),
                  const SizedBox(height: 5.0),
                  _InputField(
                      title: 'title', bottomRadius: 0.0, onSaved: (value) {}),
                  _InputField(
                    title: 'message',
                    minLines: 3,
                    maxLines: null,
                    topRadius: 0.0,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    onSaved: (value) {},
                  ),
                  const SizedBox(height: 5.0),
                  _SubmitButton(onPressed: () {
                    _mockFeedbackKey.currentState!.validate();
                  }),
                ],
              ),
            ),
          ),
        ),
        Text(
          '*This form will not send any feedback to developers. It is a mock.',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 10.0),
        ),
      ],
    );
  }
}

/// The [_InputField] class is a customizable text input field widget in Dart that includes validation
/// for empty values and email format.
class _InputField extends StatelessWidget {
  const _InputField(
      {required this.title,
      required this.onSaved,
      this.minLines = 1,
      this.maxLines = 1,
      this.topRadius = 10.0,
      this.bottomRadius = 10.0,
      this.floatingLabelBehavior = FloatingLabelBehavior.auto,
      this.isEmail = false});

  final String title;
  final void Function(String?) onSaved;
  final int minLines;
  final int? maxLines;
  final double topRadius;
  final double bottomRadius;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 14.0),
      cursorColor: googleBlue,
      decoration: InputDecoration(
        labelText: title,
        labelStyle:
            Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 14.0),
        floatingLabelBehavior: floatingLabelBehavior,
        floatingLabelStyle: const TextStyle(color: googleBlue),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: googleBlue),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topRadius),
            topRight: Radius.circular(topRadius),
            bottomLeft: Radius.circular(bottomRadius),
            bottomRight: Radius.circular(bottomRadius),
          ),
        ),
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
      ),
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      minLines: minLines,
      maxLines: maxLines,
      validator: (value) {
        // Ensure all values are full.
        if (value == null || value.isEmpty) {
          return '$title must not be empty';
        }

        // If [TextFormField] is email, then validate it.
        if (isEmail) {
          final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
          if (!emailRegExp.hasMatch(value)) {
            return 'Please enter a valid email address.';
          }
        }

        // If all is well then send null.
        return null;
      },
      onSaved: onSaved,
    );
  }
}

const double borderRadius = 15.0;
const List<double> buttonDimensions = [32.0, 90.0];

/// Mock submit button that validates the fields inside the [_InputField]
class _SubmitButton extends StatefulWidget {
  const _SubmitButton({required this.onPressed});

  final void Function() onPressed;

  @override
  State<_SubmitButton> createState() => __SubmitButtonState();
}

class __SubmitButtonState extends State<_SubmitButton> {
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
