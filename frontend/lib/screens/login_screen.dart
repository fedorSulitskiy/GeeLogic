import 'package:flutter/material.dart';
import 'package:frontend/widgets/login/login_details.dart';
import 'package:frontend/widgets/login/tutorial_carousel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
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
    );
  }
}
