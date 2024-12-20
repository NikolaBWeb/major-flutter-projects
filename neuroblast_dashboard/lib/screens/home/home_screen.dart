import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/widgets/auth/auth_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58), // Set height of AppBar
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Neuro',
                      style: TextStyle(
                        color: Theme.of(context)
                            .appBarTheme
                            .titleTextStyle
                            ?.color, // Color for "Neuro"
                        fontSize: 17,
                      ),
                    ),
                    const TextSpan(
                      text: 'BLAST ',
                      style: TextStyle(
                        color: Color(0xFFA2D06B), // Accent color for "BLAST"
                        fontSize: 17,
                      ),
                    ),
                    TextSpan(
                      text: 'Dashboard',
                      style: TextStyle(
                        color:
                            Theme.of(context).appBarTheme.titleTextStyle?.color,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          // Optionally set a maximum width for the form
          height: double.infinity,
          width: 400, // Adjust max width as needed
          padding:
              const EdgeInsets.all(16), // Optional: Add padding around the form
          child: const AuthContainer(),
        ),
      ),
    );
  }
}
