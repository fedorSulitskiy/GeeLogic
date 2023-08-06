import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the algorithm selected by user for catalogue screen
class AlgoCardSelectionState extends StateNotifier<int> {
  AlgoCardSelectionState() : super(0);

  void selectCard(int index) {
    state = index;
  }
}
final algoCardSelectionProvider =
    StateNotifierProvider<AlgoCardSelectionState, int>((ref) {
  return AlgoCardSelectionState();
});
