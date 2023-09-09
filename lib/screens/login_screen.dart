import 'package:flutter/material.dart';

import 'package:frontend/screens/laptop/login.dart';
import 'package:frontend/screens/smartphone/login.dart';
import 'package:frontend/screens/tablet/login.dart';

/// The screen that displays the login page. This is the first screen that the
/// user sees when they open the app.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 1240) {
          return const LoginLaptop();
        } else if (constraints.maxWidth > 631) {
          return const LoginTablet();
        }
        return const LoginMobile();
      }),
    );
  }
}
