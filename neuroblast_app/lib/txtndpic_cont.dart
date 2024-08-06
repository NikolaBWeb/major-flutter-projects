import 'package:flutter/material.dart';
import 'dart:math';
import 'package:neuroblast_app/text_style.dart';

var randomNum = Random();
var color = [Colors.blueAccent, Colors.amberAccent];
Color ? randColor;

class TxtAndPic extends StatefulWidget {
  const TxtAndPic({super.key});

  @override
  State<TxtAndPic> createState() {
    return _TextAndPicState();
  }
}

class _TextAndPicState extends State<TxtAndPic> {

  var randoInt = 3;

  void getRandColor() {
    setState(() {
      randoInt = randomNum.nextInt(2);
      randColor = color[randoInt];
    });
  }



  @override
  Widget build(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration:  BoxDecoration(
            color:randColor,
          ),
        ),
        TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: getRandColor,
                child: const TextStyles("Change Color!"))
      ],
    );
  }
}
