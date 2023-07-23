import 'package:flutter/material.dart';
import 'package:frontend/widgets/login/sign_in_button.dart';

class LoginDetails extends StatelessWidget {
  const LoginDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Positioned(
          top: 80.0,
          left: 20.0,
          child: SizedBox(
            width: 700.0,
            child: Text(
              'Welcome to GeeLogic',
              style: TextStyle(fontSize: 100.0, height: -1),
            ),
          ),
        ),
        const Center(child: SignInButton()),
        Positioned(
          bottom: 250.0,
          child: Text(
            'to access our resources you must sign up using Google account',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 20.0),
          ),
        ),
      ],
    );
  }
}
