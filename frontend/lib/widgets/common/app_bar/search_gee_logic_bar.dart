import 'package:flutter/material.dart';

const backgroundColor = Color.fromARGB(255, 254, 251, 255);

class SearchGeeLogicBar extends StatelessWidget {
  const SearchGeeLogicBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8.0,
        top: 16.0,
        bottom: 16.0,
        right: 54.0,
      ),
      color: backgroundColor,
      child: TextField(
        style:
            Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 18.0),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'search geeLogic',
          hintStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontSize: 18.0),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 0.0,
          ),
          isDense: true,
          icon: const Icon(
            Icons.search,
            size: 30,
          ),
        ),
        maxLines: 1,
        onChanged: (value) {},
      ),
    );
  }
}
