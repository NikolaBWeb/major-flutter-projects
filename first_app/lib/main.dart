import 'package:flutter/material.dart';
import 'package:first_app/gradient_container.dart';

const colorOne = Colors.deepOrange;
const colorTwo = Colors.deepPurple;

void main() {
  runApp(
     const MaterialApp(
      home: Scaffold(
        body:  GradientContainer( colorOne, colorTwo),
      ),
    ),
  );
}
