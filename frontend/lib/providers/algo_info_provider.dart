import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/data/algo_card_temp_data.dart';

final algoInfoProvider = Provider((ref) {
  return dummyAlgoCardData;
});