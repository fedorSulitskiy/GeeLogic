import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The [CataloguePageSelectionNotifier] class is a state notifier that keeps track of the selected page
/// on the [CatalogueScreen].
class CataloguePageSelectionNotifier extends StateNotifier<int> {
  CataloguePageSelectionNotifier() : super(0);

  void setPage(int page) {
    state = page;
  }
}

/// Provides the index of the current selected page. So if page 1 is selected, the return value will be 0.
final selectedPageProvider =
    StateNotifierProvider<CataloguePageSelectionNotifier, int>((ref) {
  return CataloguePageSelectionNotifier();
});
