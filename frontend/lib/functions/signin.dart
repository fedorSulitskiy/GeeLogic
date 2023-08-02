import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/earthengine',
  'https://www.googleapis.com/auth/devstorage.full_control',
];

Future<OAuthCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser =
      await GoogleSignIn(scopes: scopes).signIn();

  if (googleUser == null) {
    throw Exception('Something went wrong!');
  }

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the OAuthCredential
  return credential;
}
