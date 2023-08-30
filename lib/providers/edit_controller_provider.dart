import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

/// The [EditControllers] class is a Dart class that contains three controller objects for managing the
/// title, description, and code input fields in the [EditScreen].
class EditControllers {
  EditControllers({
    required this.controllerTitle,
    required this.controllerDescr,
    required this.controllerCode,
  });

  LanguageToolController controllerTitle;
  LanguageToolController controllerDescr;
  CodeController controllerCode;
}

/// The [EditControllerNotifier] class is a state notifier that manages the controllers for the title,
/// description, and code in an editing interface.
class EditControllerNotifier extends StateNotifier<EditControllers?> {
  EditControllerNotifier() : super(null);

  /// The function [setControllers] sets the controllers for the title, description, and code in an
  /// [EditControllers] state.
  /// 
  /// Args:
  ///   * `controllerTitle` (LanguageToolController): A [LanguageToolController] object that controls the
  /// title input field.
  ///   * `controllerDescr` (LanguageToolController): The [controllerDescr] parameter is an instance of the
  /// [LanguageToolController] class. It is used to control the language tool for the description field.
  ///   * `controllerCode` (CodeController): The [controllerCode] parameter is an instance of the
  /// [CodeController] class. It is used to control and manage the code input in the application.
  void setControllers(
    LanguageToolController controllerTitle,
    LanguageToolController controllerDescr,
    CodeController controllerCode,
  ) {
    state = EditControllers(
      controllerTitle: controllerTitle,
      controllerDescr: controllerDescr,
      controllerCode: controllerCode,
    );
  }

  /// The function sets the value of the state to null.
  void setNull() {
    state = null;
  }
}

/// Provides the controllers for the title, description, and code input fields in the [EditScreen].
final editControllerProvider =
    StateNotifierProvider<EditControllerNotifier, EditControllers?>((ref) {
  return EditControllerNotifier();
});
