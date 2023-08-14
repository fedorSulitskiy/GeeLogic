import 'package:flutter/material.dart';

class SubTitleText extends StatelessWidget {
  const SubTitleText({super.key, required this.title, this.fontSize = 30.0});

  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 900.0,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      child: Text(
        title,
        softWrap: true,
        overflow: TextOverflow.fade,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontSize: fontSize),
      ),
    );
  }
}
