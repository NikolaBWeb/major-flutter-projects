import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final surnameController = TextEditingController();
  void signUp() {
    if (formKey.currentState!.validate()) {
      print('Form is valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    const isLoading = false;

    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  controller: nameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Surname',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Surname is required';
                    }
                    return null;
                  },
                  controller: surnameController,
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
              controller: emailController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
              controller: passwordController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm Password is required';
                }
                return null;
              },
              controller: confirmPasswordController,
            ),
            OutlinedButton(onPressed: () {}, child: const Text('Sign Up')),
            TextButton(
              onPressed: () {},
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
