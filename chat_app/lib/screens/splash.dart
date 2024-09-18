import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  // Renamed class

  const SplashScreen({super.key}); // Renamed constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Chat"), // Title remains the same
      ),
      body: const Center(
        child: Text("Loading..."), // Body remains the same
      ),
    );
  }
}
