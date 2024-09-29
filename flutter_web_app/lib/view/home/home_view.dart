import 'package:flutter/material.dart';
import 'package:flutter_web_app/widgets/navigation_bar/navigation_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          NavigationScreenBar(),
          
        ],
      ),
    );
  }
}
