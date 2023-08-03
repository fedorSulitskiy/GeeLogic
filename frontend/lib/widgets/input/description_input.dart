import 'package:flutter/material.dart';
import 'package:frontend/widgets/input/input_content.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

class DescriptionInput extends StatelessWidget {
  const DescriptionInput(
      {super.key, required this.controller, this.width = 900.0});

  final LanguageToolController controller;
  final double width;

  @override
  Widget build(BuildContext context) {
    return LanguageToolTextField(
      padding: 8.0,
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'What is your research all about?',
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: googleGreen),
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        constraints: BoxConstraints(
          maxWidth: width,
        ),
      ),
      maxLines: null,
      minLines: 5,
      language: 'en-US',
      cursorColor: googleGreen,
    );
  }
}
