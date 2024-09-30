import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/screens/main/main_screen.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;

  // Form field controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
      Navigator.of(context).push<MaterialPageRoute<void>>(
        MaterialPageRoute(
          builder: (BuildContext ctx) => const MainScreen(),
        ),
      );
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
                child: Text(isLogin ? 'Login' : 'SignUp'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? 'Create an account '
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
