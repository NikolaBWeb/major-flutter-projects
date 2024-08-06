import 'package:flutter/material.dart';

class TextStyles extends StatelessWidget {
  const TextStyles(this.text, {super.key});

  final String text;

  @override
  Widget build(context) {
    return Text(
      text,
      style: const TextStyle(
        color:Colors.white,
        fontSize:20,
        
      ),
    );
  }
}
