import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/input_description_provider.dart';
import 'package:frontend/widgets/common/app_bar/side_menu.dart';
import 'package:frontend/widgets/input/input_content.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

class DescriptionInput extends ConsumerWidget {
  const DescriptionInput(
      {super.key, required this.controller, this.width = 900.0});

  final LanguageToolController controller;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        LanguageToolTextField(
          padding: 8.0,
          controller: controller,
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(color: iconGrey),
          decoration: InputDecoration(
            hintText: 'What is your research all about?',
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: iconGrey),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: googleGreen),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            constraints: BoxConstraints(
              maxWidth: width,
            ),
            contentPadding: const EdgeInsets.only(
              top: 0.0,
              bottom: 34.0,
              left: 8.0,
              right: 8.0,
            ),
          ),
          maxLines: null,
          minLines: 5,
          language: 'en-US',
          cursorColor: googleGreen,
          onChanged: (value) {
            ref.read(descriptionProvider.notifier).getDescription(value);
          },
        ),
        Positioned(
          bottom: 10.0,
          right: 20.0,
          child: Text(
            'Spelling and grammar checking courtesy of LanguageTool',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 12.0),
          ),
        ),
      ],
    );
  }
}
