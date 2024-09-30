import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/widgets/auth/auth_form.dart';

class AuthContainer extends StatelessWidget {
  const AuthContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/headline/NeuroBLAST - Headline (Light Gray).png',
              height: 30,
            ),
            const Spacer(),
            Image.asset(
              'assets/logo/NeuroBLAST - Symbol (Color).png',
              height: 50,
            ),
          ],
        ),
        const SizedBox(height: 20),
        const AuthForm(),
      ],
    );
  }
}
