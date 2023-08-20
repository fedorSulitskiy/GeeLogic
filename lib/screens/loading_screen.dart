import 'package:flutter/material.dart';

import 'package:frontend/widgets/common/loading_star.dart';

/// The screen that displays the loading star animation.
class StarLoadingScreen extends StatelessWidget {
  const StarLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingStar(size: 100.0,),
          ),
        ],
      ),
    );
  }
}