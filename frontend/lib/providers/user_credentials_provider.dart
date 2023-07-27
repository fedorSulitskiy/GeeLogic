// TODO: destroy this thing if it's not needed in the future

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentUserCredentials extends StateNotifier<UserCredential?> {
  CurrentUserCredentials() : super(null);

  void setCredential(UserCredential credential) {
    state = credential;
  }
}

final userCredentialsProvider = StateNotifierProvider<CurrentUserCredentials, UserCredential?>((ref) {
  return CurrentUserCredentials();
});
