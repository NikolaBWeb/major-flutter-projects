import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _enteredEmail = "";
  var _enteredPassword = ""; // Change this line
  final _formKey = GlobalKey<FormState>();
  var _isLoggedIn = true;
  File? _selectedImage;
  var _isUploading = false;
  var enteredUsername = "";

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      if (!_isLoggedIn) {
        if (_selectedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please pick an image"),
            ),
          );
          return;
        }
      }

      try {
        setState(() {
          _isUploading = true;
        });
        if (_isLoggedIn) {
          final userCredentials = await _firebase.signInWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);
        } else {
          // Attempt to create a user
          final userCredentials =
              await _firebase.createUserWithEmailAndPassword(
                  email: _enteredEmail, password: _enteredPassword);

          // Check if the user was created successfully
          if (userCredentials.user != null) {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('user_images')
                .child('${userCredentials.user!.uid}.jpg');
            await storageRef.putFile(_selectedImage!);
            final url = await storageRef.getDownloadURL();
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredentials.user!.uid)
                .set({
              'email': _enteredEmail,
              'image_url': url,
              'username': enteredUsername,
            });
          } else {
            throw FirebaseAuthException(
              code: 'user-not-created',
              message: 'User creation failed',
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (!mounted) return; // Check if the widget is still mounted
      
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "Authentication failed"),
          ),
        );
        setState(() {
          _isUploading = false;
        });
      } catch (e) {
        // Handle any other exceptions
        
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "An internal error has occurred. Please check your configuration and try again."),
          ),
        );
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              width: 200,
              child: Image.asset("assets/images/chat.png"),
            ),
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isLoggedIn)
                          UserImagePicker(imagePickFn: (image) {
                            _selectedImage = image;
                          }),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Email Address",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains("@")) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        if (!_isLoggedIn)
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Username",
                            ),
                            enableSuggestions: false,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 4) {
                                return "Please enter a valid username, at least 4 characters long";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredUsername = value!;
                            },
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return ' Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // Add this onSaved callback
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_isUploading) const CircularProgressIndicator(),
                        if (!_isUploading)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(_isLoggedIn ? " Login" : "Signup"),
                          ),
                        if (!_isUploading)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLoggedIn = !_isLoggedIn;
                              });
                            },
                            child: Text(
                              _isLoggedIn
                                  ? "Create an account"
                                  : "I already have an account.",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
