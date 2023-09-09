import 'package:flutter/material.dart';

import 'package:frontend/widgets/login/login_details.dart';

/// UI optimised for small sized screens
class LoginMobile extends StatelessWidget {
  const LoginMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.topRight,
      children: [
        // Login details, including the login/signin button and tutorial carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: LoginDetails(),
            ),
          ],
        ),
      ],
    );
  }
}
