import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is the [StateNotifier] for the title of the algorithm user is submitting.
class TitleInput extends StateNotifier<String> {
  TitleInput() : super('');

  void getTitle(String title) {
    state = title;
  }
}

/// Provides the title of the algorithm user is submitting in the [InputScreen] widget.
final titleProvider = StateNotifierProvider<TitleInput, String>((ref) {
  return TitleInput();
});