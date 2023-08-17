import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is the [StateNotifier] for the tags selected by the user.
class TagsNotifier extends StateNotifier<List<dynamic>> {
  TagsNotifier() : super([]);

  void getSelectedTags(List<dynamic> list) {
    state = list;
  }
  void removeTag(int id) {
    state = state.where((item) => item['tag_id'] != id).toList();
  }
}

/// Provides the tags selected by the user in the [InputScreen] widget.
final selectedTagsProvider =
    StateNotifierProvider<TagsNotifier, List<dynamic>>((ref) => TagsNotifier());
