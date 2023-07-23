import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/login/login_details.dart';
import 'package:frontend/widgets/login/tutorial_carousel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            right: -300,
            top: -50,
            child: Transform.rotate(
              angle: pi / 18, // Angle in radians (-pi/4 = -45 degrees)
              child: Image.asset('background.png'),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: LoginDetails(),
              ),
              Flexible(
                child: Center(
                  child: TutorialCarousel(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
