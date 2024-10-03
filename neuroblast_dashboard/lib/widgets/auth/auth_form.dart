import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/screens/main/main_screen.dart';

final _firebase = FirebaseAuth.instance;

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String _enteredEmail = '';
  String _enteredPassword = '';
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    _enteredEmail = _emailController.text.trim();
    _enteredPassword = _passwordController.text.trim();

    try {
      UserCredential userCredentials;

      if (_isLogin) {
        userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      }

      // Navigate to the MainScreen after successful authentication
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const MainScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'This email is already in use. Please use a different email.',
              ),
            ),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Authentication failed'),
          ),
        );
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 3),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 3),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  /*  const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  final regExp = RegExp(emailPattern);

                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  } else if (!regExp.hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  } */
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2,
                    ), // Color and thickness when focused
                  ),
                  // Optionally, you can customize the error border
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ), // Color when there is an error
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  /*  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a password';
                  } else if (value.trim().length < 6) {
                    return 'Password must be at least 6 characters long';
                  } */
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'SignUp'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin
                      ? "Don't have access? "
                      : 'Already have an account? Login',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
