import 'package:flutter/material.dart';
import 'package:neuroblast_app/txtndpic_cont.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({super.key});

  @override
  Widget build(context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 7, 184, 119),
      ),
      child: const Center(
        child: TxtAndPic(),
      ),
    );
  }
}
