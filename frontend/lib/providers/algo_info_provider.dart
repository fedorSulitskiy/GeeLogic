import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/data/algo_card_temp_data.dart';

// Provides all dummy data
final algoInfoProvider = Provider((ref) {
  return dummyAlgoCardData;
});

// Provides the id of the current selected algorithm (for algo_card)
class AlgoIdNotifier extends StateNotifier<String> {
  AlgoIdNotifier() : super('1');

  void getAlgoId(String id) {
    state = id;
  }
}

final algoIdProvider = StateNotifierProvider<AlgoIdNotifier, String>((ref) => AlgoIdNotifier());
