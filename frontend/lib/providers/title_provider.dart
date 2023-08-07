import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the title of the algorithm user is submitting
class TitleInput extends StateNotifier<String> {
  TitleInput() : super('');

  void getTitle(String title) {
    state = title;
  }
}
final titleProvider = StateNotifierProvider<TitleInput, String>((ref) {
  return TitleInput();
});