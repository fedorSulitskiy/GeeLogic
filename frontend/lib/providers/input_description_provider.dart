import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is the [StateNotifier] for the description of the algorithm user is submitting.
class DescriptionInput extends StateNotifier<String> {
  DescriptionInput() : super('');

  void getDescription(String description) {
    state = description;
  }
}

/// Provides the description of the algorithm user is submitting in the [InputScreen] widget.
final descriptionProvider = StateNotifierProvider<DescriptionInput, String>((ref) {
  return DescriptionInput();
});