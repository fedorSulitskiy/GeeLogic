import 'dart:js_interop';

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/python.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/providers/edit_controller_provider.dart';
import 'package:frontend/widgets/edit/cancel_button.dart';
import 'package:frontend/widgets/edit/reset_button.dart';
import 'package:frontend/widgets/input/code_input.dart';
import 'package:frontend/widgets/input/description_input.dart';
import 'package:frontend/widgets/edit/submit_button.dart';
import 'package:frontend/widgets/input/tags_input.dart';
import 'package:frontend/widgets/input/title_input.dart';

/// Widget to organise the content of the [EditScreen].
class EditContent extends ConsumerStatefulWidget {
  const EditContent({super.key, required this.algoData});

  final AlgoData algoData;

  @override
  ConsumerState<EditContent> createState() => _EditContentState();
}

class _EditContentState extends ConsumerState<EditContent> {
  final _formKey = GlobalKey<FormState>();

  late LanguageToolController _controllerTitle;
  late LanguageToolController _controllerDescr;
  late CodeController _controllerCode;

  @override
  void initState() {
    super.initState();

    // Instantiate the LanguageToolController for title
    _controllerTitle =
        LanguageToolController(initialText: widget.algoData.title);

    // Instantiate the LanguageToolController for description
    _controllerDescr =
        LanguageToolController(initialText: widget.algoData.description);

    // Instantiate the CodeController
    _controllerCode = CodeController(
      text: widget.algoData.code,
      language: widget.algoData.api == 1 ? python : javascript,
    );
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerDescr.dispose();
    _controllerCode.dispose();
    super.dispose();
  }

  /// IMPORTANT NOTE:
  /// [TitleInput], [CodeInput], [DescriptionInput] and [TagsInput] are located
  /// in the `/input` folder. Nonetheless these widgets are reused in this screen
  /// and therefore are imported here.
  @override
  Widget build(BuildContext context) {
    // If the user decided to reset the algorithms, the controllers are set to
    // the original values.
    if (!ref.watch(editControllerProvider).isNull) {
      _controllerTitle = ref.watch(editControllerProvider)!.controllerTitle;
      _controllerDescr = ref.watch(editControllerProvider)!.controllerDescr;
      _controllerCode = ref.watch(editControllerProvider)!.controllerCode;
    }

    var screenSize = MediaQuery.of(context).size;

    var width = screenSize.width * 0.6;

    if (width < 500) {
      width = screenSize.width * 0.9;
    }

    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Giving the appbar some space
                  const SizedBox(height: 25.0),
                  // Title Input
                  TitleInput(
                    controller: _controllerTitle,
                    width: width,
                  ),
                  // Code Input
                  CodeInput(
                    controller: _controllerCode,
                    width: width,
                  ),
                  const SizedBox(height: 15.0),
                  // Description Input
                  DescriptionInput(
                    controller: _controllerDescr,
                    width: width,
                  ),
                  const SizedBox(height: 15.0),
                  // Tags Inputs
                  TagsInput(
                    width: width,
                  ),
                  const SizedBox(height: 30.0),
                  // Submit and Cancel Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubmitButton(initialAlgoData: widget.algoData),
                      const SizedBox(width: 30.0),
                      const CancelButton(),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  // Reset Button
                  Center(
                      child: ResetButton(
                    algoData: widget.algoData,
                  )),
                  const SizedBox(height: 300.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
