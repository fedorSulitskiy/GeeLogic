import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputCode extends StateNotifier<String> {
  InputCode() : super('');

  void getCode(String code) {
    state = code;
  }
}

final codeProvider = StateNotifierProvider<InputCode, String>((ref) {
  return InputCode();
});

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
