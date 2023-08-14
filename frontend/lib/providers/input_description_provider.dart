import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the description of the algorithm user is submitting
class DescriptionInput extends StateNotifier<String> {
  DescriptionInput() : super('');

  void getDescription(String description) {
    state = description;
  }
}
final descriptionProvider = StateNotifierProvider<DescriptionInput, String>((ref) {
  return DescriptionInput();
});