import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/title_provider.dart';
import 'package:frontend/widgets/input/input_content.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

class TitleInput extends ConsumerWidget {
  const TitleInput({super.key, required this.controller, this.width = 900.0});

  final LanguageToolController controller;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LanguageToolTextField(
      controller: controller,
      language: 'en-US',
      style: Theme.of(context).textTheme.displayMedium!.copyWith(height: 1.0),
      decoration: InputDecoration(
        hintText: 'Title',
        hintStyle:
            Theme.of(context).textTheme.displayMedium!.copyWith(height: 1.0),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: googleYellow),
        ),
        constraints: BoxConstraints(
          maxWidth: width,
        ),
      ),
      maxLength: 60,
      cursorColor: googleYellow,
      cursorHeight: 40.0,
      maxLines: null,
      onChanged: (value) {
        ref.read(titleProvider.notifier).getTitle(value);
      },
    );
  }
}
