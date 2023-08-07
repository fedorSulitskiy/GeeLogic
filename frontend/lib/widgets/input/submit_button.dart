import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/input/upload_logic.dart';

import 'package:frontend/providers/code_provider.dart';
import 'package:frontend/providers/description_provider.dart';
import 'package:frontend/providers/map_html_code_provider.dart';
import 'package:frontend/providers/tags_provider.dart';
import 'package:frontend/providers/title_provider.dart';
import 'package:frontend/widgets/input/input_content.dart';

const double borderRadius = 30.0;
const List<double> buttonDimensions = [30.0, 100.0];

class SubmitButton extends ConsumerStatefulWidget {
  const SubmitButton({super.key});

  @override
  ConsumerState<SubmitButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends ConsumerState<SubmitButton> {
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

  SnackBar snackBar({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return SnackBar(
      backgroundColor: color,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 45.0,
          ),
          const SizedBox(width: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

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
    final isValid = ref.watch(isValidProvider);
    final title = ref.watch(titleProvider);
    final description = ref.watch(descriptionProvider);
    final code = ref.watch(codeProvider);
    final tags = ref.watch(selectedTagsProvider);
    final mapCode = ref.watch(mapWidgetHTMLCodeProvider);

    if (isValid.isValid == true) {
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
    }

    return Center(
      child: Stack(
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
              onPressed: () async {
                final scaffoldMessengerContext = ScaffoldMessenger.of(context);

                if (isValid.isValid != true ||
                    title.isEmpty ||
                    description.isEmpty) {
                  scaffoldMessengerContext.clearSnackBars();
                  scaffoldMessengerContext.showSnackBar(
                    snackBar(
                      color: googleRed,
                      icon: Icons.error_outline_outlined,
                      subtitle: isValid.isValid != true
                          ? "Please ensure that your code is verified!"
                          : title.isEmpty
                              ? "Please ensure that your algorithm has a title"
                              : "Please describe your algorithm for us",
                      title: isValid.isValid != true
                          ? "Verify your code"
                          : title.isEmpty
                              ? "Submit a title"
                              : "Submit description",
                    ),
                  );
                  return;
                }
                // Start uploading data
                setState(() {
                  _isUploading = true;
                });
                // Get current user id
                await uploadLogic(
                  context: context,
                  title: title,
                  description: description,
                  tags: tags,
                  code: code,
                  mapCode: mapCode,
                );
                // Complete the task
                setState(() {
                  _isUploading = false;
                });
                // Show confirmation to user
                scaffoldMessengerContext.clearSnackBars();
                scaffoldMessengerContext.showSnackBar(
                  snackBar(
                    color: googleGreen,
                    icon: Icons.check,
                    subtitle: "Your algorithm has been successfully added to our database!",
                    title: "Algorithm created",
                  ),
                );
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
                            fontSize: 24.0,
                          ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
