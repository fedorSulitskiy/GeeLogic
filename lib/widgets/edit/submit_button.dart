import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/helpers/edit/edit_logic.dart';
import 'package:frontend/models/algo_data.dart';
import 'package:frontend/providers/input_code_providers.dart';
import 'package:frontend/providers/input_description_provider.dart';
import 'package:frontend/providers/input_map_html_code_provider.dart';
import 'package:frontend/providers/input_tags_provider.dart';
import 'package:frontend/providers/input_title_provider.dart';
import 'package:frontend/app_theme.dart';

const double borderRadius = 30.0;
const List<double> buttonDimensions = [30.0, 100.0];

class SubmitButton extends ConsumerStatefulWidget {
  const SubmitButton({super.key, required this.initialAlgoData});

  final AlgoData initialAlgoData;

  @override
  ConsumerState<SubmitButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends ConsumerState<SubmitButton> {
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

  /// Custom [SnackBar] to display communication with the user, regarding validity
  /// of their inputs.
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
    /// Verifies if the code is valid.
    final isValid = ref.watch(isValidProvider);
    String title = ref.watch(titleProvider);
    String description = ref.watch(descriptionProvider);
    String code = ref.watch(codeProvider);
    final tags = ref.watch(selectedTagsProvider);
    final mapCode = ref.watch(mapWidgetHTMLCodeProvider);
    final isPython = ref.watch(apiLanguageProvider);

    if (isValid.isValid == true) {
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
                // Establish context before async gap
                final scaffoldMessengerContext = ScaffoldMessenger.of(context);

                // Update the data providers with data from the input fields.
                // This allows the user to not touch a certain input field
                // when editing their algorithm.
                if (title.isEmpty) {
                  title = widget.initialAlgoData.title;
                }
                if (description.isEmpty) {
                  description = widget.initialAlgoData.description;
                }
                if (code.isEmpty) {
                  code = widget.initialAlgoData.code;
                }

                // Ensure that the code provided is still valid
                if (isValid.isValid != true || tags.isEmpty) {
                  scaffoldMessengerContext.clearSnackBars();
                  scaffoldMessengerContext.showSnackBar(
                    snackBar(
                      color: GeeLogicColourScheme.red,
                      icon: Icons.error_outline_outlined,
                      subtitle: isValid.isValid != true
                          ? "Please ensure that your code is verified!"
                          : "Please ensure that you have selected at least one tag!",
                      title: isValid.isValid != true
                          ? "Verify your code"
                          : "Select at least one tag",
                    ),
                  );
                  return;
                }

                // Start uploading data
                setState(() {
                  _isUploading = true;
                });

                // Launch edit logic
                final bool isSuccess = await editLogic(
                  initialAlgoData: widget.initialAlgoData,
                  scaffoldMessengerContext: scaffoldMessengerContext,
                  context: context,
                  title: title,
                  description: description,
                  tags: tags,
                  code: code,
                  mapCode: mapCode,
                  isPython: isPython,
                  ref: ref,
                );

                // Complete the task
                setState(() {
                  _isUploading = false;
                });

                if (isSuccess) {
                  // Inform user that all is well
                  scaffoldMessengerContext.clearSnackBars();
                  scaffoldMessengerContext.showSnackBar(
                    snackBar(
                      color: GeeLogicColourScheme.green,
                      icon: Icons.check_circle_outline_rounded,
                      subtitle:
                          "Algorithm successfully updated, check it out on the catalogue page!",
                      title: "Your algorithm has been updated!",
                    ),
                  );
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
