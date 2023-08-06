import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides code input by the user for their algorithm
class InputCode extends StateNotifier<String> {
  InputCode() : super('');

  void getCode(String code) {
    state = code;
  }
}
final codeProvider = StateNotifierProvider<InputCode, String>((ref) {
  return InputCode();
});

// Provides the boolean if the the code is valid
class IsValidNotifier extends ChangeNotifier {
  bool? _isValid;

  bool? get isValid => _isValid;

  void setValid(bool? value) {
    _isValid = value;
    notifyListeners();
  }
}
final isValidProvider =
    ChangeNotifierProvider<IsValidNotifier>((ref) => IsValidNotifier());
