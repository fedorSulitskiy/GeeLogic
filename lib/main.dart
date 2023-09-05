import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:frontend/app_theme.dart';

import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/loading_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:frontend/screens/catalogue_screen.dart';
import 'package:frontend/screens/input_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WebViewPlatform.instance = WebWebViewPlatform();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// TODO: more sophisticated error handling and communication
// TODO: polish selectable text to actually be selectable
// TODO: sort out catalogue screen to actually have a named route
// TODO: potentiall ditch the layout and flexible widgets, return to stack to allow
//  single child scroll view to occupy screen until its borders AFTER RESPONSIVENESS

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    print(screenSize);
    return MaterialApp(
      title: 'Explore',
      theme: appTheme,
      routes: {
        '/input_algorithm_details': (context) => const InputScreen(),
      },
      home: SelectionArea(
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            // Return loading animation when waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const StarLoadingScreen();
            }
            // Determine if user is signed up
            if (snapshot.hasData) {
              return StreamBuilder<QuerySnapshot>(
                // Check if user's email is already in the database
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: snapshot.data!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  // Return loading animation when waiting
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const StarLoadingScreen();
                  }
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return const CatalogueScreen();
                  } else {
                    // User does not exist in the collection
                    return const SignUpScreen();
                  }
                },
              );
            }
            // Return login when first signing in
            return const LoginScreen();
          }),
        ),
      ),
    );
  }
}
