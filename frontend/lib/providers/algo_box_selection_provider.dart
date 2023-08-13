import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The [AlgoCardSelectionState] class is a state notifier that keeps track of
/// the selected card index on the catalogue screen.
class AlgoCardSelectionState extends StateNotifier<int> {
  AlgoCardSelectionState() : super(0);

  void selectCard(int index) {
    state = index;
  }
}

/// Provides the the index of the card that is selected.
final selectedAlgoIndexProvider =
    StateNotifierProvider<AlgoCardSelectionState, int>((ref) {
  return AlgoCardSelectionState();
});
