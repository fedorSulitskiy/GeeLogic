import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/userinfo.profile'
  // 'https://www.googleapis.com/auth/earthengine',
  // 'https://www.googleapis.com/auth/devstorage.full_control',
];

/// Signs in with Google service and returns the OAuthCredential which is 
/// then used to sign in with Firebase in the [SignInButton] widget.
Future<OAuthCredential> signInWithGoogle() async {
  // Trigger the silent sign-in flow
  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();

    if (googleUser == null) {
      // If silent sign-in fails, trigger the normal authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: scopes).signIn();

      if (googleUser == null) {
        throw Exception('Something went wrong!');
      }
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the OAuthCredential
    return credential;
  } catch (error) {
    throw Exception('Something went wrong while signing in with Google');
  }
}
