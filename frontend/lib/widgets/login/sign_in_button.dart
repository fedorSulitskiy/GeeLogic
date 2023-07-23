import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;
// TODO:
//  add all relevant scopes for proper authentication.
GoogleAuthProvider googleProvider = GoogleAuthProvider().addScope('https://www.googleapis.com/auth/earthengine');

const double borderRadius = 10.0;
const List<double> buttonDimensions = [70.0,150.0];

class SignInButton extends StatefulWidget {
  const SignInButton({super.key});

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.red;
  Color topColor = Colors.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2), () {
      setState(() {
        bottomColor = Colors.blue;
      });
    });

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            height: buttonDimensions[0],
            width: buttonDimensions[1],
            duration: const Duration(seconds: 2),
            curve: Curves.linear,
            onEnd: () {
              setState(() {
                index = index + 1;
                // animate the color
                bottomColor = colorList[index % colorList.length];
                topColor = colorList[(index + 1) % colorList.length];

                // animate the alignment
                begin = alignmentList[index % alignmentList.length];
                end = alignmentList[(index + 2) % alignmentList.length];
              });
            },
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: [bottomColor, topColor],
              ),
            ),
          ),
          SizedBox(
            height: buttonDimensions[0],
            width: buttonDimensions[1],
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                  ),
                ),
              ),
              onPressed: () async {
                // TODO:
                //  use userCredentials for user specific actions.
                // final userCredentials = 
                _firebase.signInWithPopup(googleProvider);
              },
              child: Image.asset(
                'assets/google_g.png',
                width: 40.0,
                height: 40.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
