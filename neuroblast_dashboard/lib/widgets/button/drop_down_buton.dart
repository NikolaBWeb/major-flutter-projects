import 'package:flutter/material.dart';

class DropDownButton extends StatefulWidget {
  const DropDownButton({super.key});

  @override
  State<DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  @override
  Widget build(BuildContext context) {
    return const Positioned(
      child: Column(
        children: [
          Text('Profile'),
          Text('Logout'),
        ],
      ),
    );
  }
}
