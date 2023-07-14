import 'package:flutter/material.dart';

class SubTitleText extends StatelessWidget {
  const SubTitleText({super.key, required this.title, this.fontSize = 30.0});

  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: fontSize),
      ),
    );
  }
}
