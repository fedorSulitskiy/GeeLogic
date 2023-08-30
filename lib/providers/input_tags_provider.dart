import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/tag.dart';

/// This is the [StateNotifier] for the tags selected by the user.
class TagsNotifier extends StateNotifier<List<Tag>> {
  TagsNotifier() : super([]);

  void getSelectedTags(List<Tag> list) {
    state = list;
  }
  void removeTag(int id) {
    state = state.where((item) => item.tagId != id).toList();
  }
}

/// Provides the tags selected by the user in the [InputScreen] widget.
final selectedTagsProvider =
    StateNotifierProvider<TagsNotifier, List<Tag>>((ref) => TagsNotifier());
