import 'package:flutter/material.dart';

import 'package:frontend/widgets/login/sign_in_button.dart';

/// Widget to display the [LoginScreen] details.
class LoginDetails extends StatelessWidget {
  const LoginDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    var topWelcomePosition =
        120.0 * screenSize.height / 739.2 * 1500 / screenSize.width;
    var signInButtonPostion = 400 * screenSize.height / 739.2 * screenSize.width / 1500;

    var welcomeTextSize =
        100.0 * screenSize.height / 739.2 * screenSize.width / 1500;
    var geeLogicTextSize =
        600.0 * screenSize.height / 739.2 * screenSize.width / 1500;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: (topWelcomePosition < 140) ? topWelcomePosition : 140,
          left: 20.0,
          child: SizedBox(
            width: 700.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to ',
                  style: TextStyle(
                      fontSize: welcomeTextSize > 50 ? welcomeTextSize : 50,
                      height: -1),
                ),
                Image.asset(
                  'assets/logo_bold.png',
                  width: geeLogicTextSize > 300 ? geeLogicTextSize : 300,
                  // height: 40.0,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: signInButtonPostion > topWelcomePosition + 160
              ? signInButtonPostion
              : topWelcomePosition + 160,
          child: const SignInButton(),
        ),
        Positioned(
          top: signInButtonPostion > topWelcomePosition + 150
              ? signInButtonPostion + 130
              : topWelcomePosition + 230,
          child: SizedBox(
            width: 610.0 * screenSize.width / 1400.0,
            child: Text(
              'to access our resources you must sign up using your Google account',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 20.0),
            ),
          ),
        ),
      ],
    );
  }
}
