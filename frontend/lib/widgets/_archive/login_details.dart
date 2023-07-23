import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

const Color googleBlue = Color.fromARGB(255, 66, 133, 244);
const double inputWidth = 400.0;

GoogleAuthProvider googleProvider = GoogleAuthProvider().addScope('https://www.googleapis.com/auth/earthengine');

class LoginDetails extends StatefulWidget {
  const LoginDetails({super.key});

  @override
  State<LoginDetails> createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      if (_isLogin) {
        // log users in
        // final userCredentials = 
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        // create new users
        // final userCredentials = 
        await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      }
    } on FirebaseAuthException catch (error) {
      // TODO:
      //  Get better error messages done.
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 35.0,
                width: 400.0,
                color: googleBlue,
                child: TextButton(
                    onPressed: () async {
                      // TODO: MAYBE implement manual sign in/log in
                      // final userCredentials = 
                      _firebase.signInWithPopup(googleProvider);
                    },
                    child: Text('google')),
              ),
              // email input
              TextFormField(
                cursorColor: googleBlue,
                decoration: const InputDecoration(
                  labelText: 'email',
                  prefixIcon: Icon(Icons.person),
                  floatingLabelStyle: TextStyle(color: googleBlue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: googleBlue),
                  ),
                  border: UnderlineInputBorder(),
                  constraints: BoxConstraints(
                    maxWidth: inputWidth,
                  ),
                ),
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid email.';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredEmail = value!;
                },
              ),
              const SizedBox(height: 10.0),
              // password input
              TextFormField(
                cursorColor: googleBlue,
                decoration: const InputDecoration(
                  labelText: 'password',
                  prefixIcon: Icon(Icons.password),
                  floatingLabelStyle: TextStyle(color: googleBlue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: googleBlue),
                  ),
                  border: UnderlineInputBorder(),
                  constraints: BoxConstraints(
                    maxWidth: inputWidth,
                  ),
                ),
                autocorrect: false,
                obscureText: true,
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.trim().length < 8) {
                    return 'Password should be at least 8 characters';
                  }
                  if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                      .hasMatch(value)) {
                    return 'Password should contain at least one uppercase letter, one lowercase letter, and one digit';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredPassword = value!;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 195.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: googleBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _submit,
                child: Text(
                  _isLogin ? 'login' : 'signup',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            SizedBox(
              width: 195.0,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin ? 'signup' : 'login',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: googleBlue),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
