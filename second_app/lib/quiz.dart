import 'package:flutter/material.dart';
import 'package:second_app/home_page.dart';
import 'package:second_app/questions.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  var activeScreen = 'start-screen';

  void switchScreen() {
    setState(() {
      activeScreen = "questions-screen";
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget =  HomePage(switchScreen);

    if (activeScreen == "questions-screen") {
      screenWidget = const Questions();
    }



    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 111, 242, 178),
                Color.fromARGB(255, 3, 137, 112)
              ],
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
