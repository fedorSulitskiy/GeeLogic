import 'package:flutter/material.dart';

import 'package:frontend/widgets/login/sign_in_button.dart';

/// Widget to display the [LoginScreen] details.
class LoginDetails extends StatelessWidget {
  const LoginDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 120.0,
          left: 20.0,
          child: SizedBox(
            width: 700.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to ',
                  style: TextStyle(fontSize: 100.0, height: -1),
                ),
                Image.asset(
                  'assets/logo_bold.png',
                  width: 600.0,
                  // height: 40.0,
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          bottom: 280.0,
          child: SignInButton(),
        ),
        Positioned(
          bottom: 200.0,
          child: Text(
            'to access our resources you must sign up using your Google account',
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
