import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The [InputCodeNotifier] class is a state notifier that allows you to get and set a code string.
class InputCodeNotifier extends StateNotifier<String> {
  InputCodeNotifier() : super('');

  void getCode(String code) {
    state = code;
  }
}

/// Provides code input by the user for their algorithm as a string.
final codeProvider = StateNotifierProvider<InputCodeNotifier, String>((ref) {
  return InputCodeNotifier();
});

/// The [IsValidNotifier] class is a [ChangeNotifier] that keeps track of a boolean value representing
/// validity of the code and notifies listeners when the value changes.
class IsValidNotifier extends ChangeNotifier {
  bool? _isValid;

  bool? get isValid => _isValid;

  void setValid(bool? value) {
    _isValid = value;
    notifyListeners();
  }
}

/// Provides the boolean if the the code is valid.
final isValidProvider = ChangeNotifierProvider<IsValidNotifier>((ref) {
  return IsValidNotifier();
});

/// The [LanguageOfAPINotifier] class is a state notifier that manages the state of a boolean value
/// representing the language of an API.
///
/// - 1 or true represents Python API
/// - 0 or false represents JavaScript API
class LanguageOfAPINotifier extends StateNotifier<bool> {
  LanguageOfAPINotifier() : super(true);

  void setLanguage(bool value) {
    state = value;
  }
}

/// Provides the boolean value representing the language of the API used by the user.
///
/// - 1 or true represents Python API
/// - 0 or false represents JavaScript API
final apiLanguageProvider =
    StateNotifierProvider<LanguageOfAPINotifier, bool>((ref) {
  return LanguageOfAPINotifier();
});
