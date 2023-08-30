import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/python.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

import 'package:frontend/widgets/_archive/login_details.dart';
import 'package:frontend/models/algo_data.dart';
import 'package:frontend/providers/edit_controller_provider.dart';
import 'package:frontend/providers/input_tags_provider.dart';

/// Widget that displays reset button at the bottom of the [EditScreen].
class ResetButton extends ConsumerStatefulWidget {
  const ResetButton({super.key, required this.algoData});

  final AlgoData algoData;

  @override
  ConsumerState<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends ConsumerState<ResetButton>
    with TickerProviderStateMixin {
  // AnimationController for the CircularProgressIndicator
  late AnimationController animationController;
  // Animation "controller"
  bool isResetting = false;

  // Re-establish the controllers to reset their values.
  LanguageToolController controllerTitle = LanguageToolController();
  LanguageToolController controllerDescr = LanguageToolController();
  CodeController controllerCode = CodeController();

  @override
  void initState() {
    // NOTE: there may be a bug since I can't get the circular progress indicator
    // to start at 0.0 consistently, instead it starts randomly :(
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    animationController.repeat(
      reverse: false,
      max: 1.0,
      min: 0.0,
      period: const Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerDescr.dispose();
    controllerCode.dispose();

    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isResetting
        ? CircularProgressIndicator(
            value: animationController.value,
            strokeWidth: 10.0,
            color: googleBlue,
          )
        : TextButton.icon(
            onPressed: () async {
              // start animation
              setState(() {
                isResetting = true;
              });

              // look at a cute animation for resetting.
              await Future.delayed(const Duration(seconds: 1));

              // stop animation
              setState(() {
                isResetting = false;
              });

              // Instantiate the LanguageToolController for title
              controllerTitle =
                  LanguageToolController(initialText: widget.algoData.title);

              // Instantiate the LanguageToolController for description
              controllerDescr = LanguageToolController(
                  initialText: widget.algoData.description);

              // Instantiate the CodeController
              controllerCode = CodeController(
                text: widget.algoData.code,
                language: widget.algoData.api == 1 ? python : javascript,
              );

              // Reset the modified values to the orginal ones
              ref.read(editControllerProvider.notifier).setControllers(
                    controllerTitle,
                    controllerDescr,
                    controllerCode,
                  );
                
              // Separately reset the selected tags
              ref.read(selectedTagsProvider.notifier).getSelectedTags(
                    widget.algoData.tags,
                  );
            },
            icon: const Icon(Icons.refresh, color: googleBlue),
            label: SizedBox(
              height: 30.0,
              child: Text(
                'reset',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: googleBlue,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          );
  }
}
