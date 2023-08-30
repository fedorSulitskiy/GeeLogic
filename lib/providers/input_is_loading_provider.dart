import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The [InputLoadingNotifier] class is a Dart class that notifies listeners when the loading state
/// of the input logic changes.
class InputLoadingNotifier extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoadingStatus(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

/// Provides the boolean if the input logic is still loading.
final inputIsLoadingProvider = ChangeNotifierProvider<InputLoadingNotifier>((ref) {
  return InputLoadingNotifier();
});