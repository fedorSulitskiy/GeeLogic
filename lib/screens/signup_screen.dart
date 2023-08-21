import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:frontend/widgets/_archive/login_details.dart';

final _firebase = FirebaseAuth.instance;

/// Constant responsible for the width of the default input field, for inputting
/// the name and surname. The width of the bio input field is calculated by
/// doubling it and adding the space between the two input fields for name and
/// surname.
const double inputWidth = 300.0;
var _enteredName = '';
var _enteredSurname = '';
var _enteredBio = '';

/// The input fields options of the signup form. Used by the [_InputField] widget
/// below, to determine mode of operation.
enum InputField {
  name,
  surname,
  bio,
}

/// The screen that displays the signup form.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentUser = _firebase.currentUser;
  var _isUploading = false;
  Uint8List? _pickedImageFileInBytes;

  /// Submit method for validating all fields in the sign up [Form] and uploading
  /// it to the Firebase Firestore.
  void _submit() async {
    // Validate the form
    final isValid = _formKey.currentState!.validate();

    // If the form is not valid, show a snackbar and return
    if (!isValid || _pickedImageFileInBytes == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in every field and select an image!'),
        ),
      );
      return;
    }

    // Save the form since its valid
    _formKey.currentState!.save();
    // Upload the data about user logic begins
    setState(() {
      _isUploading = true;
    });
    final currentUserUID = currentUser!.uid;
    
    // get image storage reference
    final imageStorageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('$currentUserUID.jpg');
    // upload image to firebase
    await imageStorageRef.putData(_pickedImageFileInBytes!);
    // get image download url to be stored in the Firebase Firestore
    final imageURL = await imageStorageRef.getDownloadURL();
    // create user on FirebaseStorage
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUID)
        .set({
      "email": currentUser!.email,
      "name": _enteredName,
      "surname": _enteredSurname,
      "bio": _enteredBio,
      "imageURL":imageURL,
    });
  }

  /// Pick image method
  void _pickImage() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult == null) {
      return;
    }

    setState(() {
      _pickedImageFileInBytes = fileResult.files.first.bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('background.png'),
          Center(
            child: SizedBox(
              height: 550,
              width: inputWidth * 2 + 100,
              child: Card(
                elevation: 10.0,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // profile picture
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor:
                            const Color.fromARGB(155, 66, 133, 244),
                        backgroundImage: _pickedImageFileInBytes != null
                            ? MemoryImage(_pickedImageFileInBytes!)
                            : null,
                        child: _pickedImageFileInBytes != null
                            ? null
                            : const Icon(
                                Icons.person_outline_rounded,
                                size: 50.0,
                              ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    // form with all input fields
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // name
                              _InputField(
                                title: 'name',
                                inputField: InputField.name,
                                icon: Icon(Icons.person),
                              ),
                              SizedBox(width: 25.0),
                              // surname
                              _InputField(
                                title: 'surname',
                                inputField: InputField.surname,
                                icon: Icon(Icons.people),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                          // bio
                          const _InputField(
                            title: 'about me',
                            inputField: InputField.bio,
                            icon: Icon(Icons.info_outlined),
                          ),
                          // submit button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: googleBlue),
                            onPressed: () {
                              _submit();
                            },
                            child: _isUploading
                                ? const SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'create profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Local input field widget, representing a customisable [TextFormField].
/// Was designed this way to allow for less code repetition, since all input
/// fields are very similar.
class _InputField extends StatelessWidget {
  const _InputField(
      {required this.title, required this.inputField, required this.icon});

  final String title;
  final InputField inputField;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: googleBlue,
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: icon,
        floatingLabelStyle: const TextStyle(color: googleBlue),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: googleBlue),
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        constraints: BoxConstraints(
          maxWidth:
              inputField == InputField.bio ? inputWidth * 2 + 25.0 : inputWidth,
        ),
      ),
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      maxLength: inputField == InputField.bio ? 280 : null,
      maxLines: inputField == InputField.bio ? 3 : 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$title must not be empty';
        }
        return null;
      },
      onSaved: (value) {
        if (inputField == InputField.name) {
          _enteredName = value!;
        }
        if (inputField == InputField.surname) {
          _enteredSurname = value!;
        } else {
          _enteredBio = value!;
        }
      },
    );
  }
}
