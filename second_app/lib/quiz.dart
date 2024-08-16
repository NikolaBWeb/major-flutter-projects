import 'package:flutter/material.dart';
import 'package:second_app/data/questions_file.dart';
import 'package:second_app/home_page.dart';
import 'package:second_app/questions.dart';
import 'package:second_app/results_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswers = [];
  var activeScreen = 'start-screen';

  void switchScreen() {
    setState(() {
      activeScreen = "questions-screen";
    });
  }
  void restartQuiz() {
    setState(() {
      activeScreen = 'home-screen';
      selectedAnswers.clear();
    });
  }

  void chosenAnswer(String answer) { 
    selectedAnswers.add(answer);
    if(selectedAnswers.length == questions.length){
      setState(() {
        activeScreen = "results-screen";  
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget =  HomePage(switchScreen);

    if (activeScreen == "questions-screen") {
      screenWidget =  Questions(chosenAnswer);
    }

    if (activeScreen == "results-screen"){
      screenWidget =  ResultsScreen(selectedAnswers,restartQuiz);
    }
    if(activeScreen == 'home-screen'){
      screenWidget = HomePage(switchScreen);
    }



    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 12, 206, 220),
                Color.fromARGB(255, 3, 149, 159)
              ],
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
