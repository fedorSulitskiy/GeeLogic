import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:frontend/providers/user_credentials_provider.dart';
import 'package:frontend/screens/catalogue_screen.dart';
import 'package:frontend/widgets/_archive/login_details.dart';

final _firebase = FirebaseAuth.instance;

const double inputWidth = 300.0;
var _enteredName = '';
var _enteredSurname = '';
var _enteredBio = '';

enum InputField {
  name,
  surname,
  bio,
}

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

  // Submit the signup form
  void _submit(userCredential) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _pickedImageFileInBytes == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in every field and select an image!'),
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    // Upload the data about user
    setState(() {
      _isUploading = true;
    });
    final currentUserUID = currentUser!.uid;
    // get image
    final imageStorageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('$currentUserUID.jpg');
    // upload image to firebase
    await imageStorageRef.putData(_pickedImageFileInBytes!);
    final imageURL = await imageStorageRef.getDownloadURL();
    // upload the data to firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUID)
        .set({
      "email": currentUser!.email,
      "name": _enteredName,
      "surname": _enteredSurname,
      "bio": _enteredBio,
      "imageURL": imageURL
    });
    setState(() {
      _isUploading = false;
    });
  }

  // Pick image method
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
    final userCredential = ref.watch(userCredentialsProvider);
    // Check if user still loggen in in development
    // print(userCredential.isNull);
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: googleBlue),
                            onPressed: () {
                              _submit(userCredential);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => const CatalogueScreen(),
                                ),
                              );
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
