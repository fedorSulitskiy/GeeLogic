import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagsNotifier extends StateNotifier<List<dynamic>> {
  TagsNotifier() : super([]);

  void getSelectedTags(List<dynamic> list) {
    state = list;
  }
  void removeTag(int id) {
    state = state.where((item) => item['tag_id'] != id).toList();
  }
}
final selectedTagsProvider =
    StateNotifierProvider<TagsNotifier, List<dynamic>>((ref) => TagsNotifier());
