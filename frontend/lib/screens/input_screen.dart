import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/app_bar.dart';
import 'package:frontend/widgets/input/input_content.dart';

class InputScreen extends StatelessWidget {
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Content
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child:  InputContent(),
            ),

            // App Bar
            Positioned(
              top: 15,
              left: 50,
              right: 50,
              child: CustomAppBar(),
            ),
          ],
        ),
      ),
    );
  }
}
