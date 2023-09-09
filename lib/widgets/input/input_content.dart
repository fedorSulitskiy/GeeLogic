import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

import 'package:frontend/widgets/input/code_input.dart';
import 'package:frontend/widgets/input/description_input.dart';
import 'package:frontend/widgets/input/submit_button.dart';
import 'package:frontend/widgets/input/tags_input.dart';
import 'package:frontend/widgets/input/title_input.dart';
import 'package:highlight/languages/python.dart';

/// Widget to organise the content of the [InputScreen].
class InputContent extends StatefulWidget {
  const InputContent({super.key});

  @override
  State<InputContent> createState() => _InputContentState();
}

class _InputContentState extends State<InputContent> {
  final _formKey = GlobalKey<FormState>();

  final _controllerTitle = LanguageToolController();
  final _controllerDescr = LanguageToolController();
  late CodeController _controllerCode;

  @override
  void initState() {
    super.initState();
    // Instantiate the CodeController
    _controllerCode = CodeController(
      text: pythonDefaultCode,
      language: python,
    );
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerDescr.dispose();
    _controllerCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  // Submit Button
                  const SubmitButton(),
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
