import 'package:flutter/material.dart';
import 'package:frontend/widgets/input/code_input.dart';
import 'package:frontend/widgets/input/description_input.dart';
import 'package:frontend/widgets/input/tags_input.dart';
import 'package:frontend/widgets/input/title_input.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

var _enteredTitle = '';
var _enteredDescription = '';
const _width = 900.0;
const googleYellow = Color.fromARGB(255, 251, 188, 5);
const googleRed = Color.fromARGB(255, 234, 67, 53);
const googleGreen = Color.fromARGB(255, 52, 168, 83);

class InputContent extends StatefulWidget {
  const InputContent({super.key});

  @override
  State<InputContent> createState() => _InputContentState();
}

class _InputContentState extends State<InputContent> {
  final _formKey = GlobalKey<FormState>();

  final List<String> listErrorTexts = [];
  final List<String> listTexts = [];
  final _controllerTitle = LanguageToolController();
  final _controllerDescr = LanguageToolController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerDescr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _width,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Giving the appbar some space
                  const SizedBox(height: 120),
                  // Title Input
                  TitleInput(
                    controller: _controllerTitle,
                  ),
                  // Code Input
                  const CodeInput(),
                  const SizedBox(height: 30.0),
                  // Description Input
                  DescriptionInput(controller: _controllerDescr),
                  const SizedBox(height: 30.0),
                  // Tags Inputs
                  const TagsInput(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
