import 'package:flutter/material.dart';

class SideColumn extends StatelessWidget {
  const SideColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      width: 350,
    );
  }
}