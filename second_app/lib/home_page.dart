import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage(this.startQuiz, {super.key});

  final void Function() startQuiz;

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Centers the column contents vertically
        children: [
          Image.asset(
            "assets/images/quiz-logo.png",
            width: 300,
            color: const Color.fromARGB(151, 255, 255, 255),
          ),

          /* Opacity(
            opacity: 0.5,
            child: Image.asset(
              "assets/images/quiz-logo.png",
              width: 300,
            ),
          ), */
          const SizedBox(
              height: 80), // Adds space between the image and the text
          Text(
            "Learn Flutter the fun way!",
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 30, // Increases the text size
              fontWeight: FontWeight.bold, // Makes the text bold
            ),
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              overlayColor: Colors.white,
            ),
            onPressed: () {
              startQuiz();
            },
            label: const Text(
              "Start Quiz!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20, // Increases the text size
                fontWeight: FontWeight.bold, // Makes the text bold
              ),
            ),
            icon: const Icon(Icons.arrow_right_alt),
          ),
        ],
      ),
    );
  }
}
